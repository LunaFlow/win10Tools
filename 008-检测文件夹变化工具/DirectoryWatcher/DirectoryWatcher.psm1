# version 0.4



<#
.DESCRIPTION
  创建一个目录监测器对象
.INPUTS
  无
.OUTPUTS
  目录监测器对象
.EXAMPLE

$TargetDir = "$PsScriptRoot\被监测的目录"
$watcher = New-DirectoryWatcher `
  -Path $TargetDir `
  -Filter '*.*' `
  -EventFilter 'Changed,Created,Deleted,Renamed' `
  -MessageData @{ index = 0 } `
  -Action {

#    $EventArgs 这个对象有3个属性:
#      ChangeType ： 修改类型，
#      Fullpath ： 被修改的文件（或目录）的完整路径
#      Name ： 被修改的文件（或目录）的名字

#    $Event.MessageData就是由-MessageData参数指定的对象
    $data = $event.MessageData
    $data.index += 1
    Write-Host "[$($data.index)] - 你 $($EventArgs.ChangeType) 了 $($EventArgs.fullpath) "
  }
# 这里你可以继续干其他事情，因为DirectoryWatcher是以多线程异步的方式来实现的，不会阻塞你的代码


#>
function New-DirectoryWatcher {
  [CmdletBinding()]
  param(
    # 要监视的文件夹的全路径
    [Parameter(Mandatory, Position=0)]
    [string]$Path,
    # 文件名过滤模式（默认是*）
    [string]$Filter = '*',
    # 事件发生时要执行的动作
    [Parameter(Mandatory)]
    [scriptblock]$Action,
    # 需要监听的事件类型，逗号隔开：Changed（修改）, Created（创建）, Deleted（删除）, Renamed（重命名）
    [string]$EventFilter = 'Changed,Created,Deleted,Renamed',
    # Notify过滤器，指定当哪些元素(文件名，文件夹名，最后修改时间)发生变化时才会触发事件
    # 具体可以用的值请参考：https://docs.microsoft.com/en-us/dotnet/api/system.io.notifyfilters?view=netframework-4.7.2
    [System.IO.NotifyFilters]$NotifyFilter = 'FileName, DirectoryName, LastWrite',
    # 不包含子文件夹
    [switch]$NotIncludeSubdirectories,
    # 如果你在 DebounceMS 毫秒内做了很多次某种类型的修改，也只是触发一次该类型的事件
    [int]$DebounceMS = 1000,
    # 传送给Action块的附加数据，可以通过 $Event.MessageData获取
    [PSObject]$MessageData = $null
  )



  $ArgMap = @{
    Path = (Resolve-Path -LiteralPath $Path).ToString()
    Filter = $Filter
    Action = $Action
    NotifyFilter = $NotifyFilter
    NotIncludeSubdirectories  = [bool] $NotIncludeSubdirectories
    DebounceMS = $DebounceMS
    MessageData = $MessageData
    EventsToListen = @($EventFilter -split '[\s,]+')
  }

  $MsgQueue = New-Object System.Collections.Concurrent.BlockingCollection[object]

  $ps = __NewPowerShell {
    param($__psScriptRoot, $ArgMap, $MsgQueue)
    Import-Module $__psScriptRoot\private.psm1 -Scope local
    $context = Start-WatchDirectory @ArgMap
    while($true) {
      $msg = $null
      if ($MsgQueue.TryTake([ref]$msg, 100)) {
        $type = $msg.type
        if ($type -eq 'Begin') {
          __AddEventHandlers $context
          $msg.sender.Add('Done')
        } elseif ($type -eq 'Stop') {
          __RemoveEventHandlers $context
          $msg.sender.Add('Done')
        } elseif ($type -eq 'Dispose') {
          __RemoveEventHandlers $context
          $context.Watcher.Dispose()
          $msg.sender.Add('Done')
          #Write-Host "watcher" "Disposed"
          break
        }
      }
    }
  } ($PsScriptRoot,$ArgMap, $MsgQueue)
  $null= $ps.BeginInvoke()

  return __NewWatcher $MsgQueue $ps

}

function __NewPowerShell([string]$ScriptBlock, $Arguments = @(), $RunspacePool = $null) {
  $PowerShell = [powershell]::Create()
  $null= $PowerShell.AddScript($ScriptBlock)
  ForEach($a in $Arguments) { $null= $PowerShell.AddArgument($a) }
  if ($RunspacePool) {
    $PowerShell.RunspacePool = $RunspacePool
  } else {
    $Runspace = [runspacefactory]::CreateRunspace($Host)
    $PowerShell.runspace = $Runspace
    $Runspace.Open()
  }
  return $PowerShell
}



function __NewWatcher($MsgQueue, $PowerShell) {
  $w = New-Object PSObject

  $ME = New-Object PSObject @{
    sender = New-Object System.Collections.Concurrent.BlockingCollection[object]
    isDisposed = $false
  }

  @{
    Begin = {
      if ($ME.isDisposed) { throw "已经Dispose" }
      $null= $MsgQueue.Add(@{type = "Begin"; sender = $ME.sender })
      $null= $ME.sender.Take()
    }

    Stop = {
      if ($ME.isDisposed) { return }
      $null= $MsgQueue.Add(@{type = "Stop"; sender = $ME.sender })
      $null= $ME.sender.Take()
    }

    Dispose = {
      if ($ME.isDisposed) { return }
      $ME.isDisposed = $true
      $null= $MsgQueue.Add(@{type = "Dispose"; sender = $ME.sender })
      $null= $ME.sender.Take()
      Start-Sleep -Milliseconds 10
      $null= $PowerShell.Stop()
      $null= $PowerShell.Dispose()
    }

  }.GetEnumerator() | ForEach-Object {
    Add-Member -InputObject $w -MemberType ScriptMethod -Name $_.Key -Value $_.Value.GetNewClosure()
  }

  return $w
}


Export-ModuleMember -Function New-DirectoryWatcher

