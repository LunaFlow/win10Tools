
$script:LOG_FILE_LOCATION = "$PsScriptRoot\log.txt"

function log($msg) {
  $t = get-date -format 'yyyy-MM-dd HH:mm:ss'
  "[$t]$msg" | Out-File $script:LOG_FILE_LOCATION -Append -Encoding utf8
}


function __PSVariableList($PSVList = @()) {
  $xs = [System.Collections.Generic.List[System.Management.Automation.PSVariable]]::new($PSVList.count / 2)
  $numPSVList = $PSVList.count
  for($i = 0; $i -lt $numPSVList; $i += 2 ) {
    $null= $xs.add( [System.Management.Automation.PSVariable]::new($PSVList[$i], $PSVList[$i + 1]) )
  }
  , $xs
}

function __invokeScriptBlockWithContext([scriptblock]$sb, $psvList = @(), $functionMap = $null) {
  , $sb.InvokeWithContext($functionMap, (__PSVariableList $psvList))
}

function __renameBy([scriptblock]$scriptblock, $item, $count = 0) {
  $private:fullpath = $item.fullname
  $private:N = [System.IO.Path]::GetFileNameWithoutExtension($fullpath)
  $private:E = [System.IO.Path]::GetExtension($fullpath)
  if ($E) { $E = $E.substring(1) }
  $private:D = [System.IO.Path]::GetDirectoryName($fullpath)
  $private:res = __invokeScriptBlockWithContext $scriptblock (
      'N', $N,
      'E', $E,
      'D', $D,
      'FP', $item.fullname,
      '_', $item,
      'C', $count,
      'YMD', (get-date -format yyyyMMdd),
      'hms', (get-date -format HHmmss)
  )
  [pscustomobject]@{ From=$fullpath ; To=(getNewPath $res $N $E $D) }
}

function GetResult($now, $old) {
  if ($now -eq '*') { return $old }
  else { return $now }
}


function getNewPath($r, $N0, $E0, $D0) {
  if ($r.count -eq 1) {
    $N = GetResult $r[0] $N0
    $E = $E0 ; $D = $D0
  } elseif ($r.count -eq 2) {
    $N = GetResult $r[0] $N0
    $E = GetResult $r[1] $E0
    $D = $D0
  } elseif ($r.count -eq 3) {
    $D = GetResult $r[0] $D0
    $N = GetResult $r[1] $N0
    $E = GetResult $r[2] $E0
  } else {
    throw "脚本块必须返回1到3个字符串"
  }

  $p = $D + "\" + $N
  if ($E) { $p = $p  + "." + $E }

  return [System.IO.Path]::GetFullPath($p)
}


function listview($xs) {  #{{{
    $xs | Format-List (
    @{
      name='旧位置'
      expression = {
        [System.IO.Path]::GetDirectoryName($_.From)
      }
    },
    @{
      name='旧文件名'
      expression = {
        [System.IO.Path]::GetFileName($_.From)
      }
    },
    @{
      name='新位置'
      expression = {
        [System.IO.Path]::GetDirectoryName($_.To)
      }
    },
    @{
      name='新文件名'
      expression = {
        [System.IO.Path]::GetFileName($_.To)
      }
    }
  )
} #}}}

function simpleview($xs) {
  $xs | Format-Table -AutoSize -Wrap -Property (
    @{
      name = '旧路径'
      expression = { $_.From }
    },
    @{
      name = '新路径'
      expression = { $_.To }
    }
  )
}

function CheckConflict($items) { #{{{
  $conflicts =  @( $items | Where-Object { test-path -literalPath $_.To } )
  if ($conflicts) {
    $conflicts | ForEach-Object {
      write-host -f red "[错误] 从 $($_.From) 到 $($_.To)，目标路径已经存在！"
    }
    return $true
  }

  $conflicts = @( $items | Group-Object To | Where-Object { $_.count -gt 1 } | ForEach-Object { $_.group } )
  if ($conflicts) {
    $conflicts | ForEach-Object {  write-host -f red "[错误] 从 $($_.From) 到 $($_.To)，目标路径重复！" }
    return $true
  }
  return $false
} #}}}


function __doMove($old, $new) {  #{{{
  $dir = split-path $new -parent
  if (!(test-path -literalPath $dir)) {
    mkdir $dir
  }
  log '[Move]<--------'
  log "[From]$old"
  log "[To  ]$new"
  move-item -LiteralPath $old -Destination $new
  $isOK = $?
  if ($isOK) {
    log "[Restore]Move-Item -LiteralPath '$($new.replace("'","''"))' -Destination '$($old.replace("'","''"))'"
    log "[Done]-------->"
  } else {
    log "[Error]!!! ----------->"
  }
  return $isOK
}  #}}}




<#
.DESCRIPTION
一个非常灵活的重命名工具。

用法举例
------------------------------------
# 修改文件名（后缀名和文件夹不变）
  dir *.mp3 | PowerRename { "$C-$N" }
# 修改后缀名（文件名和文件夹不变）
  dir *.txt | PowerRename { "*" ; "log"  }
# 修改文件名和后缀名（文件夹不变）
  dir *.txt | PowerRename { "$C-$N"; "log" }
# 修改文件夹（文件名和后缀名不变，相当于移动）
  dir *.txt | PowerRename { "C:\temp"; "*"; "*" }


# 当脚本块返回1个字符串时：只修改文件名
# 当脚本块返回2个字符串时：只修改文件名和后缀名
# 当脚本块返回3个字符串时：修改文件夹，文件名和后缀名（相当于移动加重命名）

注意：使用 * 来表示保持某部分不变

更多例子可以使用 Get-Help PowerRename -full 来查看


预定义变量
------------------------------------
  $N       源文件名（不包含后缀名）
  $E       源后缀名（不包含.）,没有后缀名的时候为空字符串("")
  $D       源所在文件夹的全路径
  $FP      源文件的全路径
  $_       源文件对象(类型：System.IO.FileInfo)
  $C       计数器（默认从1开始，初始值可调整）
  $YMD     当前日期
  $hms     当前时间

字符串操作
------------------------------------
  $string | Left $i             取左边 i 个字符
  $string | Right $i            取右边 i 个字符
  $string | DelLeft $i          删除左边 i 个字符
  $string | DelRight $i         删除右边 i 个字符
  $String.Insert (Int32 i, string s)  在位置 i 插入字符串 s
  $String.PadLeft(Int32, Char)          左边补充
  $String.PadRight(Int32, Char)         右边补充
  $String.Remove(Int32 i, Int32 n)      在位置 i 删除 n 个字符
  $String.Replace(String, String)       替换
  $String.Trim()
  $String.Trim(Char[])
  $String.TrimEnd(Char[])
  $String.TrimStart(Char[])


FileInfo常用属性/方法
------------------------------------
  Attributes        获取或设置当前文件或目录的特性
  LastAccessTime    获取或设置上次访问当前文件或目录的时间
  LastWriteTime     获取或设置上次写入当前文件或目录的时间
  Length            获取当前文件的大小（以字节为单位）

Cmdlet
------------------------------------
  Get-Random       获取随机数
  New-Guid         获取全局唯一id
  Get-Date         获取时间
  Get-FileHash     获取文件Hash


.INPUTS
使用 Get-ChildItem 获取的文件对象
.OUTPUTS
无
.EXAMPLE
# 修改文件名（后缀名和文件夹不变）
dir *.mp3 | PowerRename { "$C-$N" }
.EXAMPLE
# 只修改后缀名（文件名和文件夹不变）
dir *.txt | PowerRename { "*" ; "log"  }
.EXAMPLE
# 修改文件名和后缀名（文件夹不变）
dir *.txt | PowerRename { "$C-$N"; "log" }
.EXAMPLE
# 修改文件夹（文件名和后缀名不变，相当于移动）
dir *.txt | PowerRename { "C:\temp"; "*"; "*" }
.EXAMPLE
# 在文件名前面加上MD5
dir * | PowerRename {  $m = ($_ | Get-FileHash -a md5).hash; "$m-$N" }

#>

function PowerRename () {
  [CmdletBinding()]
  param(
    # 包含重命名逻辑的脚本块
    # 当脚本块返回1个字符串时：只修改文件名
    # 当脚本块返回2个字符串时：只修改文件名和后缀名
    # 当脚本块返回3个字符串时：修改文件夹，文件名和后缀名（相当于移动加重命名）
    [parameter(Mandatory,Position=0)]
    [scriptblock]$ScriptBlock,
    [parameter(Mandatory, ValueFromPipeline)]
    [psobject[]]$InputObject,
    # 视图类型：Simple，List
    [ValidateSet('Simple', 'List')]$View = "Simple",
    # 计数器的起始值
    [int]$StartCount = 1
  )

  if ($PSCmdlet.MyInvocation.ExpectingInput) {
    $InputObject = @($input)
  }

  $_input = @( $InputObject |  Where-Object { ! $_.PSIsContainer  } )
  if ($_input.count -eq 0) {
    Write-Host -f red "没有任何输入文件"
    return
  }

  log "开始"

  $count = $StartCount
  $xs = @( foreach($it in $_input) {
    __renameBy $ScriptBlock $it $count
    ++$count
  } )


  $notChanged = @( $xs | Where-Object {  $_.From -eq $_.To  } )
  if ($notChanged) {
    "以下文件不需要处理："
    $notChanged | ForEach-Object { Write-Host -f yellow $_.From }
  }

  $xs = @( $xs | Where-Object {  $_.From -ne $_.To  }  )

  if (! $xs) {
    Write-Host -f yellow "没有文件需要重命名！"
    return
  }

  if (CheckConflict $xs) {
    return
  }

  write-host -f yellow "以下是需要处理的文件：`n--------------------------------------"
  if ($View -eq 'Simple') {
    simpleview $xs
  } elseif ($View -eq 'List') {
    listview $xs
  }

write-host -f yellow  @"
需要处理的文件  ：$($xs.count)
不需要处理的文件：$($notChanged.count)

请检查重命名结果是否正确
"@

  [string]$rand = get-random -Maximum 999 -Minimum 100
  $confirm = Read-Host "开始执行重命名，输入 $rand 确认该操作"
  if ($confirm -ne $rand) {
    write-host "操作被取消"
    return
  }


  $failList = @( $xs | ForEach-Object {
    $isOK = __doMove $_.From $_.To
    if (! $isOK) { $_ }
  } )
  if ($failList) {
     Write-Host -f red "部分重命名操作发生错误，请查看日志文件 ${script:LOG_FILE_LOCATION}"
  } else {
    write-host -f green "全部成功"
    log "[all-done]"
  }

}



filter Left($i) {
  $_.Substring(0,$i)
}
filter DelLeft($i) {
  $_.Remove(0,$i)
}
filter Right($i) {
  $_.Substring($_.Length - $i)
}
filter DelRight($i) {
  $_.Substring(0, $_.Length-$i)
}


Export-ModuleMember -Function PowerRename,Left,Right,DelLeft,DelRight

