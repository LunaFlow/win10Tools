Import-Module $PSSCRIPTROOT\choice.psm1

$Options = ("Windows 2000", "Windows XP", "Windows Vista")
$result = Choice "选择你最喜欢的windows版本：" $Options  8 $true
Write-Host ""
    # Choice 包含四个参数 $Title——标题, $Options——选项, $CountDown=10 —— 倒计时，默认10秒, $OpenCountDown=$false —— 倒计时是否开启，默认不开启
    # Choice "选择要测试的项目：" $Options 5 $true
if ($result.isTimeout) {
  Write-Host "超时了！！！"
}
Write-Host "你最喜欢的windows是： $($Options[$result.choice]) "
Read-Host "按Enter退出"

