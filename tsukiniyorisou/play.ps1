Import-Module $PSSCRIPTROOT\choice.psm1

$OptionChr = ("樱小路露娜", "小仓朝日", "大藏里想奈", "大蔵衣远", "艾斯特·加拉哈·阿诺兹", "退出")

$Navel = Get-Content -Encoding UTF8 .\Navel.json | ConvertFrom-Json
# 八种基本情绪列表
$emotions = $Navel.emotions_comment_cn
# 音频文件文件夹
$WavFilePath = "wav"

$小仓朝日 = $Navel.asa
# $樱小路露娜 = $Navel.lun
$柳之濑凑 
$尤希尔
$花之宫瑞穂
$山吹八千代
$名波七爱
$萨莎
$杉村北斗
# $大藏里想奈 = $Navel.res
$大蔵衣远 = $Navel.aeo
${让-皮埃尔·史丹利}
${艾斯特·加拉哈·阿诺兹} = $Navel.est


class character {
  [String] $characterName
  [Array]  $chrArray
}
  function PlayAudio
  {
    param($wavFile)
    $player = New-Object -TypeName System.Media.SoundPlayer
    $player.SoundLocation = "$PSScriptRoot\$WavFilePath\$wavFile"
    $player.Load()
    $player.Play()
  }
  function choseEmotions {
    param (
      $emotions,
      $chr
    )
    Clear-Host
    $tempArray = $chr.chrArray | Where-Object {$_.emotions -eq $emotions.emotions_en}
    $dialogues = $tempArray | ForEach-Object {$_.cn}
    [System.Collections.ArrayList]$arraylist = $dialogues
    $arraylist.add("退出")
    do{
      $result = Choice "请选择$($chr.characterName)$($emotions.emotions_cn)的台词列表" $arraylist
      if (!($arraylist[$result.choice] -eq "退出")) {
          PlayAudio($tempArray[$result.choice].fileName)
      }
      
    }while( !($arraylist[$result.choice] -eq "退出") )
    break;
    
  }
  function choseChr {
    param (
      $chr
    )
    
    $level = $true
            while($level) {
              Clear-Host
              $result = Choice "选择$($chr.characterName)的情感：" $emotions
              switch($emotions[$result.choice]){
                "恐惧"{
                  choseEmotions @{"emotions_en"= "fear"; "emotions_cn"="恐惧"} $chr
                  break;
                }
                "生气"{
                  choseEmotions @{"emotions_en"= "anger"; "emotions_cn"="生气"} $chr
                  break;
                }
                "悲伤"{
                  choseEmotions @{"emotions_en"= "sadness"; "emotions_cn"="悲伤"} $chr
                  break;
                }
                "厌恶"{
                  choseEmotions @{"emotions_en"= "disgust"; "emotions_cn"="厌恶"} $chr
                  break;
                }
                "开心"{
                  choseEmotions @{"emotions_en"= "joy"; "emotions_cn"="开心"} $chr
                  break;
                }
                "惊讶"{
                  choseEmotions @{"emotions_en"= "surprise"; "emotions_cn"="惊讶"} $chr
                  break;
                }
                "信任"{
                  choseEmotions @{"emotions_en"= "trust"; "emotions_cn"="信任"} $chr
                  break;
                }
                "平静"{
                  choseEmotions @{"emotions_en"= "anticipation"; "emotions_cn"="平静"} $chr
                  break;
                }
                "退出"{
                  $level = $flase
                }
              }
            }
  }

  function Main{
    $flag = $true
    while($flag){
      Clear-Host
      $result = Choice "选择想听的角色声音：" $OptionChr
      Clear-Host
      switch($OptionChr[$result.choice]){
        "樱小路露娜" {
          $chr = New-Object -TypeName "character"
          $chr.characterName = "樱小路露娜"
          $chr.chrArray = $Navel.lun
          choseChr $chr

        }
        "小仓朝日" {
            $dialogues = $小仓朝日 | ForEach-Object {$_.cn}
            [System.Collections.ArrayList]$arraylist = $dialogues
            $arraylist.add("退出")
            do {
              $result = Choice "请选择小仓朝日的台词" $arraylist
              if (!($arraylist[$result.choice] -eq "退出")) {
                  PlayAudio($小仓朝日[$result.choice].fileName)
              }
              
            } while(!($arraylist[$result.choice] -eq "退出"))
        }
        "大藏里想奈" {
          $chr = New-Object -TypeName "character"
          $chr.characterName = "大藏里想奈"
          $chr.chrArray = $Navel.res
          choseChr $chr
          
        }
        "大蔵衣远" {
            $dialogues = $大蔵衣远 | ForEach-Object {$_.cn}
            [System.Collections.ArrayList]$arraylist = $dialogues
            $arraylist.add("退出")
          do{
            $result = Choice "请选择大蔵衣远的台词" $arraylist
            if (!($arraylist[$result.choice] -eq "退出")) {
                PlayAudio($大蔵衣远[$result.choice].fileName)
            }
          } while(!($arraylist[$result.choice] -eq "退出"))
        }
        "艾斯特·加拉哈·阿诺兹" {
            $dialogues = ${艾斯特·加拉哈·阿诺兹} | ForEach-Object {$_.cn}
            [System.Collections.ArrayList]$arraylist = $dialogues
            $arraylist.add("退出")
            do{
              $result = Choice "请选择艾斯特的台词" $arraylist
              if (!($arraylist[$result.choice] -eq "退出")) {
                  PlayAudio(${艾斯特·加拉哈·阿诺兹}[$result.choice].fileName)
              }
              
            } while(!($arraylist[$result.choice] -eq "退出"))
        }
        "退出" {
            $flag = $flase
        }
      }
    }
  }
Main
# Test 
