# 获取文件
$fileList = [regex]::matches( $(cat -Encoding UTF8 .\Navel.json),'(?i)[^"]+\.wav').value | % {$_.split(".")[0]}
$allAduionFilePath = "D:\out\Temp\All"
$fileList | % {cp $("$allAduionFilePath\$_.ogg") .\temp}
# 转换
$oggFile = ls -Path *.ogg -Recurse
$oggFile | % { .\oggdec.exe $_ }

#删除
$oggFile = ls -Path *.ogg -Recurse
$oggFile | % { rm $_ }

#移动
$wavFile = ls -Path *.wav 
$wavFile | % { mv $_ ./wav }