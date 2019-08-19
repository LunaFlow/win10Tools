if (Test-Path $PSSCRIPTROOT\_config\config.json) {
    $config = Get-Content -Encoding UTF8 $PSSCRIPTROOT\_config\config.json | ConvertFrom-Json
    while(1){
        $value = Get-Clipboard
        write-host "DEBUG:$value"
        $pattern_pan = 'https?://pan.baidu.com/s/'
        $pattern_Magnet = 'magnet:?[^\"]+'
        $pattern_ed2k = 'ed2k://.*'
        if ($value -eq $null) {
            
        }elseif ([regex]::Match($value, $pattern_pan).Success) {
            Start-Process $config.PanDownload
            $null | clip.exe
            sleep 8
            Set-Clipboard $value
            $null | clip.exe
            $value = $null
        }elseif ([regex]::Match($value, $pattern_Magnet).Success -or [regex]::Match($value, $pattern_ed2k).Success) {
            Start-Process $config.Thunder
            $null | clip.exe
            sleep 12
            Set-Clipboard $value
            $null | clip.exe
            $value = $null
        }
        sleep 1
    }
}