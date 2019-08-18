function Choice($Title, $Options, $CountDown=10, $OpenCountDown=$false) {

  function InitMenuData($title = "", $Options = $(throw "必须指定该参数"), $countdown = -1) {
   [pscustomobject]@{
      Title = $title
      Options = $Options
      CurrentIndex = 0
      Top = [Console]::Top
      Left = [Console]::Left
      CountDown = $countdown
      totalCount = $countdown
      hasPressed = !($CountDown -gt 0)
      start = Get-Date
    }
  }

  function ClearCurrentConsoleLine()
  {
      $currentLineCursor = [Console]::CursorTop
      [Console]::SetCursorPosition(0, [Console]::CursorTop)
      [Console]::Write(' ' * [Console]::WindowWidth)
      [Console]::SetCursorPosition(0, $currentLineCursor)
  }

  function ShowMenu($MenuData) {
    [console]::SetCursorPosition($MenuData.Left, $MenuData.Top)
    Write-Host $MenuData.Title
    $Options = $MenuData.Options
    $curIndex = $MenuData.CurrentIndex
    for ($i = 0; $i -lt $Options.count; ++$i) {
      $text = "  " + $Options[$i]
      if ($i -eq $curIndex) {
        Write-Host -ForegroundColor $host.ui.rawui.BackgroundColor -BackgroundColor $host.ui.rawui.ForegroundColor $text
      } else {
        Write-Host $text
      }
    }

    if (! $MenuData.hasPressed) {
      [Console]::WriteLine("")
      [Console]::WriteLine("倒计时：$($MenuData.CountDown) 秒");
    } else {
      [Console]::WriteLine("")
      ClearCurrentConsoleLine
    }
  }

  function MakeResult($choice, $isTimeout = $false) {
    return [pscustomobject]@{ choice = $choice; isTimeout = $isTimeout }
  }

#############################
  
  [Console]::WriteLine('')
  $MenuData = InitMenuData $Title $Options $CountDown
  if (!$OpenCountDown) {
      $MenuData.hasPressed = $true
  }
  ShowMenu $MenuData
  $interval = 100
  
  

  while (1) {
    $oldCD = $MenuData.CountDown
    $MenuData.CountDown = [int] ($MenuData.totalCount - ((Get-Date) - $MenuData.start).totalseconds)
    if ($oldCD -ne $MenuData.CountDown) { ShowMenu $MenuData }
    if ($MenuData.CountDown -eq 0 -and $OpenCountDown) { return MakeResult $MenuData.CurrentIndex $true }
    if ([console]::KeyAvailable ) {  $MenuData.hasPressed = $true; ShowMenu $MenuData ; break; }
    else  { sleep -Millisecond $interval }
  }

  while (1) {
    $keyinfo = [console]::readkey($true)
    if ($keyinfo.key -eq 'UpArrow') {
      if ($MenuData.CurrentIndex -gt 0) {
        $MenuData.CurrentIndex = $MenuData.CurrentIndex - 1
        ShowMenu $MenuData
      }
    } elseif ($keyinfo.key -eq 'DownArrow') {
      if ($MenuData.CurrentIndex -ne ($MenuData.Options.count - 1)) {
        $MenuData.CurrentIndex = $MenuData.CurrentIndex + 1
        ShowMenu $MenuData
      }
    } elseif ($keyinfo.key -eq 'Enter') {
     return MakeResult $MenuData.CurrentIndex
    }
  }
}

