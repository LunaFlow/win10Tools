function GetNow { get-date -Format HH:mm:ss }
$global:DebugPreference = "Continue"
Import-Module $psScriptRoot\DirectoryWatcher
Clear-Host

$TargetDir = "D:\800-vsCode-work\820Python\DailyAttendance\config"
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
    Write-Host "[$($data.index)] - 你 $($EventArgs.ChangeType) 了 $($EventArgs.fullpath) "
    if($EventArgs.ChangeType -eq 'Changed'){
      cd 'D:\800-vsCode-work\820Python\DailyAttendance'
      git add .
      git commit -m 'cookie change'
      git push
    }
  }

#####################################################################################
# 这里你可以继续干其他事情，因为DirectoryWatcher是以多线程异步的方式来实现的，不会阻塞你的代码

# Start-Process $TargetDir
Write-Host "[$(GetNow)] 开始：被监测的目录是 " -NoNewline; Write-Host -f yellow $TargetDir
Write-Host "[$(GetNow)] 测试：去修改，新建，重命名，删除文件和目录"

while(1) {
# 开始监视
  $watcher.Begin()
  Write-Host -f green "[$(get-date -Format HH:mm:ss)] 监测已经开始"
  Sleep 10

}

