$r = curl https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt
$r.Content > $PSSCRIPTROOT/trackers_best.txt
$config = "bt-tracker="
$array = @()
foreach($line in [System.IO.File]::ReadLines("trackers_best.txt")){
 if($line.length -gt 0){
  $array+=$line
 }
}
if($array.length -gt 0){
    $config+=$($array -join ',')
    [System.IO.File]::ReadLines("C:\Users\Anchan\OneDrive\_Common_Portable_SoftWare\Aria2_Win\aria2\aria2.conf") -replace '^bt-tracker=.*', $config | Out-File -Encoding UTF8 C:\Users\Anchan\OneDrive\_Common_Portable_SoftWare\Aria2_Win\aria2\aria2.conf
}
