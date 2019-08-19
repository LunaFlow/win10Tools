##[Ps1 To Exe]
##
##Kd3HDZOFADWE8uO1
##Nc3NCtDXTlaDjofG5iZk2WrgQWAqYPm0t7OD1oiq+tbTmibYTZ8ZUGtElTv1FF+BTvscBKUhu94dRiEVH+Fa3YbfJMKxQJ46ocZHTquHpb1J
##Kd3HFJGZHWLWoLaVvnQnhQ==
##LM/RF4eFHHGZ7/K1
##K8rLFtDXTiW5
##OsHQCZGeTiiZ4tI=
##OcrLFtDXTiW5
##LM/BD5WYTiiZ4tI=
##McvWDJ+OTiiZ4tI=
##OMvOC56PFnzN8u+Vs1Q=
##M9jHFoeYB2Hc8u+Vs1Q=
##PdrWFpmIG2HcofKIo2QX
##OMfRFJyLFzWE8uK1
##KsfMAp/KUzWJ0g==
##OsfOAYaPHGbQvbyVvnQX
##LNzNAIWJGmPcoKHc7Do3uAuO
##LNzNAIWJGnvYv7eVvnQX
##M9zLA5mED3nfu77Q7TV64AuzAgg=
##NcDWAYKED3nfu77Q7TV64AuzAgg=
##OMvRB4KDHmHQvbyVvnQX
##P8HPFJGEFzWE8tI=
##KNzDAJWHD2fS8u+Vgw==
##P8HSHYKDCX3N8u+Vgw==
##LNzLEpGeC3fMu77Ro2k3hQ==
##L97HB5mLAnfMu77Ro2k3hQ==
##P8HPCZWEGmaZ7/K1
##L8/UAdDXTlaDjofG5iZk2WrgQWAqYPm0t7OD1oiq+tbTmibYTZ8ZUGtElTv1FF+BTvscBKUhu94dRiEaqDnyZFsJkgBGwkrGFwyJ7z1lLm/0kI0dZnYj7wqGzo/UUAl6Uzw=
##Kc/BRM3KXhU=
##
##
##fd6a9f26a06ea3bc99616d4851b372ba
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '400,400'
$Form.text                       = "P站爬取小工具"
$Form.TopMost                    = $false
$Icons                           = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
$Form.Icon                       = $Icons

$lable                             = New-Object system.Windows.Forms.Label
$lable.text                        = "p站画师id/url"
$lable.AutoSize                    = $true
$lable.width                       = 25
$lable.height                      = 10
$lable.location                    = New-Object System.Drawing.Point(10,20)
$lable.Font                        = 'Microsoft Sans Serif,10'

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 154
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(100,20)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$Button1                         = New-Object system.Windows.Forms.Button
# $Button1.text                    = [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]::UTF8.GetBytes("开始爬取"))
$Button1.text                    = "start"
$Button1.width                   = 100
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(290,20)
$Button1.Font                    = 'Microsoft Sans Serif,10'

$DataGridView1                   = New-Object system.Windows.Forms.DataGridView
$DataGridView1.width             = 398
$DataGridView1.height            = 150
$DataGridView1.location          = New-Object System.Drawing.Point(0,250)

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = ""
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(20,120)
$Label1.Font                     = 'Microsoft Sans Serif,10'

$lableCookie                     = New-Object system.Windows.Forms.Label
$lableCookie.text                = "cookies"
$lableCookie.AutoSize            = $true
$lableCookie.width               = 25
$lableCookie.height              = 10
$lableCookie.location            = New-Object System.Drawing.Point(10,50)
$lableCookie.Font                = 'Microsoft Sans Serif,10'

$TextBox2                        = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline              = $false
$TextBox2.width                  = 154
$TextBox2.height                 = 20
$TextBox2.location               = New-Object System.Drawing.Point(100,50)
$TextBox2.Font                   = 'Microsoft Sans Serif,10'

$lableJson                     = New-Object system.Windows.Forms.Label
$lableJson.text                = "jsonPath"
$lableJson.AutoSize            = $true
$lableJson.width               = 25
$lableJson.height              = 10
$lableJson.location            = New-Object System.Drawing.Point(10,80)
$lableJson.Font                = 'Microsoft Sans Serif,10'

$TextBox3                        = New-Object system.Windows.Forms.TextBox
$TextBox3.multiline              = $false
$TextBox3.width                  = 154
$TextBox3.height                 = 20
$TextBox3.location               = New-Object System.Drawing.Point(100,80)
$TextBox3.Font                   = 'Microsoft Sans Serif,10'

$Button2                         = New-Object system.Windows.Forms.Button
$Button2.text                    = "导出urls开始下载"
$Button2.width                   = 150
$Button2.height                  = 40
$Button2.location                = New-Object System.Drawing.Point(220,120)
$Button2.Font                    = 'Microsoft Sans Serif,10'

$Button3                         = New-Object system.Windows.Forms.Button
$Button3.text                    = "批量重命名"
$Button3.width                   = 100
$Button3.height                  = 50
$Button3.location                = New-Object System.Drawing.Point(250,160)
$Button3.Font                    = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($lable,$TextBox1,$Button1,$DataGridView1,$Label1,$lableCookie,$TextBox2,$Button2,$Button3, $TextBox3, $lableJson))

class Pinter
{
    $PinterName
    $Pics = @{}
}

function sendRequest {
    param(
            $PicPageUrl_queue,
            $WebSession,
            $Method,
            $Headers,
            $ContentType
            )
    # 多线程
    $throttleLimit = 5
    $SessionState = [system.management.automation.runspaces.initialsessionstate]::CreateDefault()
    $Pool = [runspacefactory]::CreateRunspacePool(1, $throttleLimit, $SessionState, $Host)
    $Pool.Open()
    
    $ScriptBlock = {
        param(
            $PicPageUrl,
            $WebSession,
            $Method,
            $Headers,
            $ContentType
            )
        Trap [System.Net.WebException] {
            $Global:ErrorUrls = @()
            $ErrorUrls += $PicPageUrl
            Continue
        }
        $completed = $false
        $response = $null
        # 重试次数
        $Retries = 4
        $retryCount = 0
        # 重试等待时间
        $SecondsDelay = 5

        # 失败重试
        while (-not $completed) {
            try {
                $response = (Invoke-WebRequest -UseBasicParsing -TimeoutSec 10 -Uri $PicPageUrl -WebSession $WebSession -Method $Method -Headers $Headers -ContentType $ContentType)
                if ($response.StatusCode -ne 200) {
                    throw "Expecting reponse code 200, was: $($response.StatusCode)"
                }
                $completed = $true
            } catch {
                New-Item -ItemType Directory -Force -Path C:\logs\
                $RandomNum = (Get-Random -Maximum 99 -Minimum 10)
                "$(Get-Date -Format G): Request to $PicPageUrl failed. $_" | Out-File -FilePath "C:\logs\myscript$RandomNum.log" -Encoding utf8 -Append

                if ($retrycount -ge $Retries) {
                    Write-Warning "Request to $PicPageUrl failed the maximum number of $retryCount times."
                    throw
                } else {
                    Write-Warning "Request to $PicPageUrl failed. Retrying in $SecondsDelay seconds."
                    Start-Sleep ($SecondsDelay * $retryCount)
                    $retrycount++
                }
            }
        }
        
        return $response
    }
    
    $threads = @()
    $responses = @()

    $handles = for ( ; $PicPageUrl_queue.Count -gt 0; ) {
        $PicPageUrl = $PicPageUrl_queue.Dequeue()
        $powershell = [powershell]::Create().AddScript($ScriptBlock).AddArgument($PicPageUrl).AddArgument($WebSession).AddArgument($Method).AddArgument($Headers).AddArgument($ContentType)
        $powershell.RunspacePool = $Pool
        $powershell.BeginInvoke()
        $threads += $powershell
    }
    
    do { 
    $i = 0
    $done = $true
    foreach ($handle in $handles) {
        if ($handle -ne $null) {
            if ($handle.IsCompleted) {
            $response = $threads[$i].EndInvoke($handle)
            # if($response[0].BaseResponse.ResponseUri.getType().Name -eq "Uri"){
                $responses += $response
            # }
            $threads[$i].Dispose()
            $handles[$i] = $null
        } else {
            $done = $false
        }
        }
        $i++ 
    }
    if (-not $done) { Start-Sleep -Milliseconds 500 }
    } until ($done) 
    
    return $responses
}

$Button1.Add_Click(
    {
        if (Test-Path -PathType Container -Path C:\logs\) {
            Remove-Item -Recurse -Force -Path C:\logs\
        }
        # Pinter
        $global:Pinter = [Pinter]::new()

        [System.Uri]$Uri = "https://www.pixiv.net"
        $StartUrl = $TextBox1.text

        if ($StartUrl -match "^\d+") {
            $StartUrl = "https://www.pixiv.net/ajax/user/$StartUrl/profile/all"
        } elseif ($StartUrl -match "^https?://www\.pixiv\.net/member_illust\.php\?&?id=\d+") {
            $Query = ([uri]$StartUrl).Query
            $uid = ([regex]'(?<=id=)\d+(?<=&)?').Matches($Query).Value
            $StartUrl = "https://www.pixiv.net/ajax/user/$uid/profile/all"
        } elseif ($StartUrl -match "^https?://www.pixiv.net/member.php\?id=\d+") {
            $uid = $StartUrl.Split("?")[-1].Split("=")[-1]
            $StartUrl = "https://www.pixiv.net/ajax/user/$uid/profile/all"
        } else {
            
        }


        $PicPageUrl_queue = [System.Collections.Queue]::Synchronized( (New-Object System.Collections.Queue) )
        $ContentType = "application/json"
        $Method = 'GET'

        $PCookies = $TextBox2.text
        $PCookies = ""
        if("" -eq $PCookies){
            $PCookies = "first_visit_datetime_pc=2019-01-28+19%3A08%3A38; p_ab_id=2; p_ab_id_2=3; p_ab_d_id=1076131239; yuid_b=EjZ0UWk; privacy_policy_agreement=1; _ga=GA1.2.152830667.1548670144; c_type=30; a_type=0; b_type=1; login_ever=yes; __utmv=235335808.|2=login%20ever=yes=1^3=plan=normal=1^5=gender=male=1^6=user_id=13166582=1^9=p_ab_id=2=1^10=p_ab_id_2=3=1^11=lang=zh=1; module_orders_mypage=%5B%7B%22name%22%3A%22sketch_live%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22tag_follow%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22recommended_illusts%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22everyone_new_illusts%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22following_new_illusts%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22mypixiv_new_illusts%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22spotlight%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22fanbox%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22featured_tags%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22contests%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22user_events%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22sensei_courses%22%2C%22visible%22%3Atrue%7D%2C%7B%22name%22%3A%22booth_follow_items%22%2C%22visible%22%3Atrue%7D%5D; ki_r=; PHPSESSID=13166582_fa26068178a0ac237e29b59c54cd03b2; ki_t=1554686222211%3B1564534941680%3B1564534941680%3B5%3B8; __utma=235335808.152830667.1548670144.1564534881.1564720869.76; __utmc=235335808; __utmz=235335808.1564720869.76.27.utmcsr=saucenao.com|utmccn=(referral)|utmcmd=referral|utmcct=/search.php; __utmt=1; _gid=GA1.2.848520620.1564720878; tag_view_ranking=0xsDLqCEW6~1ws9v5O0zQ~OANc1ppJ6G~zIv0cf5VVk~RTJMXD26Ak~iFcW6hPGPU~BXJoC8jDBr~LLyDB5xskQ~sIvsEMlQNn~PGXMWrFFIN~EGefOqA6KB~qvqXJkzT2e~m3EJRa33xU~Mw8DgYbhu2~Ce-EdaHA-3~Ie2c51_4Sp~qWFESUmfEs~ETjPkL0e6r~KN7uxuR89w~aKhT3n4RHZ~Ao3GraaJ8o~Lt-oEicbBr~LEmyJ-RN72~Ttb-cC0pim~75zhzbk0bS~0RlPEGkN4V~ikuNRT0q2E~1M7aQ3CWH2~Zvw5VVgYdH~5oPIfUbtd6~WWqIngy74s~9xJZx40wfj~2EpPrOnc5S~at5kYG0Mvu~rqvM6GS14_~RcahSSzeRf~X_1kwTzaXt~3wD6-b7Xs3~y8GNntYHsi~qtVr8SCFs5~g-eUicvps8~VgyqBztLOH~G4SjhiACOU~mHukPa9Swj~Je_lQPk0GY~EttOqqgGxI~_vCZ2RLsY2~uC2yUZfXDc~uvBGOtCzqF~liM64qjhwQ~engSCj5XFq~HY55MqmzzQ~TWrozby2UO~xha5FQn_XC~cb91hphOyK~65aiw_5Y72~wgrA9w_7EX~azESOjmQSV~noTdeU-y2b~oo9mFpF2gh~pdxLFdmKDj~BU9SQkS-zU~GNcgbuT3T-~33yyxLOuUf~bOxKD7_VRv~Xs3nxH7Ckz~cN8Z0POSF4~KvAGITxIxH~Xzqr_WHxts~_hSAdpN9rx~0GyqV8JLK3~EcfG8vCObf~-_wpANQaY0~bcAbumoPKA~yv-jklQ__Z~TcgCqYbydo~ZTBAtZUDtQ~69v3aNJnS3~WVrsHleeCL~xa5-CDAPro~9bToVapebH~Ti1gvrVQFO~Np09pTbQD_~Z1nxjmEni2~x_OI1QNIhl~VNNjr-4cx-~zhidwuyCQH~FH69TLSzdM~-R9MLPiQ6P~_Ao0JDLbJN~Z3EYKXmKss~9L6u8C5rXO~gtCILpPR9I~OmR2xVm9oQ~wjW5Y25gNH~bXMh6mBhl8~fbUyQrXMR3~xJsg2eui8K~pz_K0y0ep-~Mezz_Dzov-; __utmb=235335808.11.10.1564720869"
        }
        $Cookie = New-Object System.Net.Cookie
        $WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        $Cookie.Domain = $uri.DnsSafeHost
        foreach ($str in  $PCookies.split(";"))
        {
            $temp=$str.trim().split("=");
            $Cookie.Name = $temp[0]; 
            $Cookie.Value = $temp[1]; 
            $WebSession.Cookies.Add($Cookie)
        }

        $Headers = @{
            # Add name and value of headers
            referer = "https://www.pixiv.net/";
            "user-agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36"
        }


        # first request
        $response = (Invoke-WebRequest -UseBasicParsing -Uri $StartUrl -WebSession $WebSession -Method $Method -Headers $Headers -ContentType $ContentType)

        $jsonObj = ConvertFrom-Json -InputObject $response.content
        $PageId= $jsonObj.body.illusts
        foreach ($pageUrl in $PageId.psobject.properties.name){ 
            $url = "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=" + $pageUrl
            $PicPageUrl_queue.enqueue( $url )
        }
        [System.Collections.ArrayList]$responses = @()
        
        $cnt = 0
        do {
            $tempArray = sendRequest -PicPageUrl_queue $PicPageUrl_queue -WebSession $WebSession -Method $Method -Headers $Headers -ContentType $ContentType
            foreach ($temp in $tempArray){
                $responses.add($temp)
            }
            for ($i = 0; $i -lt $responses.Count; $i++) {
                $response = $responses[$i]
                if( ($response.StatusCode -ne 200) -and ($null -ne $response.StatusCode) ) {
                    $PicPageUrl_queue.enqueue( $response.BaseResponse.ResponseUri.AbsoluteUri )
                    $responses.RemoveAt($i)
                }elseif($null -eq $response.StatusCode) {
                    $responses.RemoveAt($i)
                }
            }
            $cnt++
            if ($cnt -gt 5) {
                break;
            }
        } while ($PicPageUrl_queue.Count -gt 0)
        
        
        $picUrlOriginals = @()
        # 解析url专用
        Add-Type -AssemblyName System.Web

        foreach ($response in $responses){
            if ( ($null -ne $response.content) -and ("" -ne $response.content) ) {
                $RegObj = [Regex]::Matches($response.content, '(?<=illust:)\s*{.*?}(?=,user)')
                $str = $RegObj.Value.Trim()
                $jsonObj = ConvertFrom-Json -InputObject $str
                # [System.Web.HttpUtility]::ParseQueryString 解析参数
                $PicPageUrlId = [System.Web.HttpUtility]::ParseQueryString($response.BaseResponse.ResponseUri.Query)["illust_id"]
                # pic title
                $title = $jsonObj.$PicPageUrlId.title
                
                # pic user
                $userName = $jsonObj.$PicPageUrlId.userName
                $userAccount = $jsonObj.$PicPageUrlId.userAccount
                $PicDirName = $userName + "-" + $userAccount
                
                $Pinter.PinterName = $PicDirName
                # page Count
                $pageCount = $jsonObj.$PicPageUrlId.userIllusts.$PicPageUrlId.pageCount
                # pic url
                $picUrlOriginal = $jsonObj.$PicPageUrlId.urls.original
                
                if ($null -ne $pageCount -and $pageCount -gt 1) {
                    for ($i = 0; $i -lt $pageCount; $i++) {
                        $url = $picUrlOriginal.replace("_p0", "_p"+$i)
                        $picUrlOriginals += $url
                        $temptitle = $title + $i
                        # name - url
                        # Add-Member -InputObject $Pinter.Pics -Name $temptitle -Value $picUrlOriginal.replace("_p"+$i, "_p"+($i+1)) -MemberType NoteProperty
                        $Pinter.Pics.$temptitle = $url
                    }
                }else{
                    if ( ($null -ne $picUrlOriginal) -and ("" -ne $picUrlOriginal) ) {
                        $picUrlOriginals += $picUrlOriginal
                        # name - url
                        # Add-Member -InputObject $Pinter.Pics -Name $title -Value $picUrlOriginal -MemberType NoteProperty
                        $tempTitle = $title + (Get-Random -Maximum 99 -Minimum 10)
                        $Pinter.Pics.$temptitle = $picUrlOriginal
                    }
                    
                }
            }
            
        }
        $global:picUrlList = $picUrlOriginals
        if ($picUrlOriginals.length -gt 0) {
            ConvertTo-Json $Pinter | Out-File ("_"+$Pinter.PinterName + ".json")
        }
        $Label1.text = "爬取结束：共抓取到"+$picUrlOriginals.length+"条"
    }
)

$Button2.Add_Click(
    {
        if ($picUrlList.length -gt 1) {
            $picUrlList > urls.txt
        }
        $downloadpath = Join-Path (Get-Location) "temp"
        if (!(Test-Path -PathType Container -Path $downloadpath)){
            mkdir "temp"
        }
        $aria2 = Get-Process | Where-Object {$_.ProcessName -eq "aria2c"}
        
        Start-Process $PSSCRIPTROOT\_aria2\AriaNg.html

        if ($null -eq $aria2) {
            # start aria2
            $dirPath = (Get-Location)
            $fileName = "temp.jpg"
            $maxConcurrentDownloads = 5
            $maxConnectionPerServer = 5
            $ScriptPath = (Get-Location).path
            $inputFile = Join-Path $ScriptPath "./_aria2/aria2.session"
            $saveSession = Join-Path $ScriptPath "./_aria2/aria2.session"
            $header = '"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"'
            $argList = " --user-agent=`"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36`" --header=`"referer: https://www.pixiv.net`" --header=`"$header`" -d $dirPath --out=$fileName --input-file=$inputFile --save-session=$saveSession --max-concurrent-downloads=$maxConcurrentDownloads --max-connection-per-server=$maxConnectionPerServer --enable-rpc=true --rpc-allow-origin-all=true --rpc-listen-all=true --continue=true"
            Start-Process -FilePath ".\_aria2\aria2c.exe" -ArgumentList $argList -NoNewWindow
            # Start-Process -FilePath .\aria2c.exe -ArgumentList " --referer=https://www.pixiv.net/ -d $dirPath --input-file=$inputFile --save-session=$saveSession --max-concurrent-downloads=$maxConcurrentDownloads --max-connection-per-server=$maxConnectionPerServer --enable-rpc=true --rpc-allow-origin-all=true --rpc-listen-all=true --continue=true" -NoNewWindow
        }
        Start-Sleep -Seconds 1.5
        $refererUrl = "https://www.pixiv.net"
        $List = @()
        if (-not ($picUrlList.length -gt 1)) {
            foreach($url in Get-Content .\urls.txt) {
                $List += $url
            }
        } else{
            $List = $picUrlList
        }
        $downloadpath = $downloadpath.Replace("\","\\")
        
        foreach($picUrl in $List){
            $param = '
                {
                    "jsonrpc": "2.0",
                    "id": "qwer",
                    "method": "aria2.addUri",
                    "params": [
                        ["' + $picUrl + '"],
                        {"refer": "'+ $refererUrl +'","dir":"'+ $downloadpath +'"}
                    ]
                }
            '
            
            Invoke-WebRequest -UseBasicParsing http://localhost:6800/jsonrpc -ContentType "application/json" -Method POST -Body $Param
        }
    }
)

$Button3.Add_Click({
    if ($null -eq $Pinter) {
        $Label1.text = "读取json进行重命名中"
        # $jsonPath = Read-Host "输入json路径"
        $jsonPath = $TextBox3.text

        $Pinter = $null
        if ($jsonPath.EndsWith(".json")) {
            $Pinter = Get-Content $jsonPath | ConvertFrom-Json
            Move-Item $jsonPath ./temp/
        }else{
            $jsonPath = Join-Path $jsonPath ("_"+$jsonPath.split("\")[-1] + ".json")
            if (!(Test-Path -PathType Container -Path $jsonPath)) {
                return;
            }
            $Pinter = Get-Content $jsonPath | ConvertFrom-Json
        }
         
        $picFileList = Get-ChildItem .\temp\
        foreach($picFile in $picFileList){    
            $props = Get-Member -InputObject $Pinter.Pics -MemberType NoteProperty
            foreach($picName in $props){
                $propValue = $Pinter.Pics | Select-Object -ExpandProperty $picName.Name
                if ([regex]::Match($propValue, $picFile.Name).Success) {
                    Move-Item $picFile.FullName (Join-Path $picFile.DirectoryName ($picName.Name+"."+$picFile.Name.split(".")[-1]));
                    continue;
                }
            }
        }

        Move-Item "temp" $Pinter.PinterName
    }else{
        $downloadpath = Join-Path (Get-Location) "temp"

            Get-ChildItem $downloadpath | %{
                foreach($picName in $Pinter.Pics.keys){
                    if ([regex]::Match($Pinter.Pics[$picName], $_.Name).Success) {
                        Move-Item $_.FullName (Join-Path $_.DirectoryName  ($picName+"."+$_.Name.split(".")[-1]));
                        $Pinter.Pics.Remove($picName)
                        continue;
                    }
                }
            }
        }
        
        Move-Item ("_"+$Pinter.PinterName+".json") .\temp\
        Move-Item "temp" $Pinter.PinterName
    }
})

$Form.ShowDialog()