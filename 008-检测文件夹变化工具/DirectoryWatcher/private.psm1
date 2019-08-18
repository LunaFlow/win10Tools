# 构造定时器 {{{
function __MakeTimer($SharedData, $TaskObject) {
  $Timer = [timers.Timer] @{
    Interval = $SharedData.DebounceMS
    AutoReset = $false
  }

  $null= Register-ObjectEvent $Timer elapsed -Action {
    $MD = $event.MessageData
    $SharedData = $MD.SharedData
    $TaskKey = $MD.TaskKey

    $curTask = $SharedData.TaskTable[$TaskKey]
    $null= $SharedData.TaskTable.Remove( $TaskKey )

    $curTask.Timer.stop()
    $curTask.Timer.dispose()
    $curTask.Timer = $null

    $null= New-Event -SourceIdentifier 'DirectoryWatcher_Event_9d38x8ga66uzmjdlr26l2zrdpr0qx3j5' `
      -EventArguments $curTask.EventArgs `
      -MessageData $SharedData.ScriptBlock_MessageData
  } -MessageData (New-Object PSObject @{ SharedData = $SharedData; TaskKey = $TaskObject.Key })

  return $Timer
}


function __NewTimerTask($key, $theEVENTARGS) {
  New-Object PSObject @{
    Key = $key
    Timer = $null
    Id = [guid]::NewGuid().ToString()
    EventArgs = $theEVENTARGS
  }
}
# }}}


function Start-WatchDirectory(
    [string]$Path,
    [string]$Filter = '*',
    [scriptblock]$Action,
    [System.IO.NotifyFilters]$NotifyFilter = 'FileName, DirectoryName, LastWrite',
    [switch]$NotIncludeSubdirectories,
    [int]$DebounceMS = 1000,
    [PSObject]$MessageData = $null,
    [string[]]$EventsToListen = @('Changed', 'Created', 'Deleted', 'Renamed')
  ) {


  $private:SharedData = New-Object PSObject @{
    TaskTable = @{}
    DebounceMS = $DebounceMS
    ScriptBlock_MessageData = $MessageData
  }

  Register-EngineEvent -Action $Action -SourceIdentifier 'DirectoryWatcher_Event_9d38x8ga66uzmjdlr26l2zrdpr0qx3j5'

  #构造watcher
  $private:WatcherOptions = @{
    Path = $Path
    IncludeSubdirectories = ! $NotIncludeSubdirectories
    NotifyFilter = $NotifyFilter
  }

  if ($Filter) { $WatcherOptions.Filter = $Filter }
  $private:Watcher = [System.IO.FileSystemWatcher]$WatcherOptions

  return New-Object PSObject @{
    Watcher = $Watcher;
    EventsToListen = $EventsToListen;
    SharedData = $SharedData }

}

function __AddEventHandlers($context) {
  $EventsToListen = $context.EventsToListen
  $Watcher = $context.Watcher
  $SharedData = $context.SharedData

  foreach($EventName in $EventsToListen) {
    # 安装watcher的事件handler
    $null= Register-ObjectEvent $Watcher $EventName -Action {
      $MD = $event.MessageData
      $SharedData = $MD.SharedData
      $key = "$($EVENTARGS.ChangeType):$($EVENTARGS.FullPath)"
      $t = $SharedData.TaskTable[$key]
      if (! $t) {
        $t = & $MD.__NewTimerTask $key $EVENTARGS
        $t.Timer = & $MD.__MakeTimer $SharedData $t
        $SharedData.TaskTable[$key] = $t
        $t.Timer.start()

        #Write-Debug "新建 task >>> $key >>> $($SharedData.Tasks.count)"
      }  else {
        $t.Timer.stop()
        $t.Timer.start()
        #Write-Debug "复用 task >>> $key >>> $($SharedData.Tasks.count)"
      }
    } `
    -MessageData @{
      __NewTimerTask = Get-Command __NewTimerTask
      __MakeTimer = Get-Command __MakeTimer
      SharedData = $SharedData
    } `
    -SourceIdentifier "${EventName}_FileSystemWatcher_Event_n0wugbz5i9doz44x3d0ly3575j4drbca"

  }
  $Watcher.EnableRaisingEvents = $true
}

function __RemoveEventHandlers($context) {
  foreach($EventName in $context.EventsToListen) {
    Unregister-Event -SourceIdentifier "${EventName}_FileSystemWatcher_Event_n0wugbz5i9doz44x3d0ly3575j4drbca" -Force
  }
}

Export-ModuleMember -Function Start-WatchDirectory,__AddEventHandlers,__RemoveEventHandlers

