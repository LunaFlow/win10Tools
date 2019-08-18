Import-Module $PSSCRIPTROOT\choice.psm1

$OptionChr = ("樱小路露娜", "小仓朝日", "大藏里想奈", "大蔵衣远", "退出")

$Navel = cat -Encoding UTF8 .\Navel.json | ConvertFrom-Json
$小仓朝日 = $Navel.asa
$樱小路露娜 = $Navel.lun
$柳之濑凑 
$尤希尔
$花之宫瑞穂
$山吹八千代
$名波七爱
$萨莎
$杉村北斗
$大藏里想奈 = $Navel.res
$大蔵衣远 = $Navel.aeo
${让-皮埃尔·史丹利}
${艾斯特·加拉哈·阿诺兹} = $Navel.est
# write-host $大藏里想奈[0].cn
function markfile{
    param($list, $chrName)
    $list | % { New-Item -type File -Name "$($_.fileName.Split(".")[0])——$chrName-$($_.cn).mk" -Path ".\wav"  }
}
  function Main{
    markfile $小仓朝日 "小仓朝日"
    markfile $樱小路露娜 "樱小路露娜"
    markfile $大藏里想奈 "大藏里想奈"
    markfile $大蔵衣远 "大蔵衣远"
    markfile ${艾斯特·加拉哈·阿诺兹} "艾斯特·加拉哈·阿诺兹"
    
  }
Main
