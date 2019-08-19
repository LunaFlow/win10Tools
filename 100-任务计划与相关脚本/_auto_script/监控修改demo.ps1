function GetNow { get-date -Format HH:mm:ss }
$global:DebugPreference = "Continue"
Import-Module DirectoryWatcher
Clear-Host

function DirWatch($TargetDir){
  $watcher = New-DirectoryWatcher `
  -Path $TargetDir `
  -Filter '*.*' `
  -EventFilter 'Changed,Created,Deleted,Renamed' `
  -MessageData @{ index = 0 } `
  -Action {
<#
    $EventArgs 这个对象有3个属性:
      ChangeType ： 修改类型，
      Fullpath ： 被修改的文件（或目录）的完整路径
      Name ： 被修改的文件（或目录）的名字

    $Event.MessageData就是由-MessageData参数指定的对象
#>
    $data = $event.MessageData
    $data.index += 1
    
    if(test-path 'C:/pslog'){
      mkdir pslog
      ni changeFile.log
    }
    Write-Host "[$($data.index)] - 你 $($EventArgs.ChangeType) 了 $($EventArgs.fullpath) "
    "[$($data.index)] - 你 $($EventArgs.ChangeType) 了 $($EventArgs.fullpath) " >> changeFile.log
    
    
  }

#####################################################################################
# 这里你可以继续干其他事情，因为DirectoryWatcher是以多线程异步的方式来实现的，不会阻塞你的代码
$watcher.Begin()

  while(1) {
  # 开始监视
    Write-Host -f green "[$(get-date -Format HH:mm:ss)] 监测已经开始"
    Sleep 10
  }

}

function main {
  $path = "$PsScriptRoot\被监测的目录"
  DirWatch("$PsScriptRoot\被监测的目录")
}

main