# cv-build.ps1 — CV 四段双联构图渲染（v3）
# 用法：pwsh -File cv-build.ps1 [-Only cv1]

param([string]$Only = '')

$FF   = 'E:\个人\个人学习-AI产品经理\_browse\node_modules\@ffmpeg-installer\win32-x64\ffmpeg.exe'
$SRC  = 'E:\个人\个人学习-AI产品经理\08-原型素材\CV+多模态'
$ROOT = 'C:\Users\MeeCreeps\_cv'
$SEG  = Join-Path $ROOT 'seg'
$OUTD = 'E:\个人\个人学习-AI产品经理\10-个人网站'
$ASSD = Join-Path $ROOT 'ass'

foreach ($d in @($SEG, $ASSD)) { if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d | Out-Null } }

# ---- 机位表：左卡裁切 / 右卡裁切（源坐标 1728x1080）----
$CAM = @{
  'full'        = @{ l = '1728:968:0:112';    ls = '1500:840'; lx = 210; ly = 34;  r = $null }
  'dual'        = @{ l = '783:660:96:194';    ls = '830:700';  lx = 70;  ly = 60;  r = '757:364:919:216'; rs = '900:433'; rx = 940; ry = 200 }
  'msg'         = @{ l = '735:620:135:290';   ls = '830:700';  lx = 70;  ly = 60;  r = '757:364:919:216'; rs = '900:433'; rx = 940; ry = 200 }
  'think'       = @{ l = '664:560:150:430';   ls = '830:700';  lx = 70;  ly = 60;  r = '757:364:919:216'; rs = '900:433'; rx = 940; ry = 200 }
  'think2'      = @{ l = '664:560:150:540';   ls = '830:700';  lx = 70;  ly = 60;  r = '757:364:919:216'; rs = '900:433'; rx = 940; ry = 200 }
  'think+zoom'  = @{ l = '664:560:150:430';   ls = '830:700';  lx = 70;  ly = 60;  r = '400:192:1090:290'; rs = '900:433'; rx = 940; ry = 200 }
  'think2+zoom' = @{ l = '664:560:150:540';   ls = '830:700';  lx = 70;  ly = 60;  r = '400:192:1024:380'; rs = '900:433'; rx = 940; ry = 200 }
}

# ---- 分镜表 ----
$PLAN = @{
  'cv1' = @{
    file = '功能点1：全场景动态感知解析.mp4'
    shots = @(
      @{ cam='full';  ss=0.0;  d=1.4 },
      @{ cam='dual';  ss=1.4;  d=2.8 },
      @{ cam='msg';   ss=4.2;  d=2.8 },
      @{ cam='think'; ss=7.0;  d=5.0 }
    )
    subs = @(
      @{ a=0.2;  b=1.4;  s='一个院子，四路画面';            n='' },
      @{ a=1.6;  b=4.2;  s='问一句，它就去查';              n='不用先设规则' },
      @{ a=4.4;  b=7.0;  s='换个问法，从头算一遍';          n='16:43:33 那一句' },
      @{ a=7.2;  b=12.0; s='先摊开怎么想，再给结论';        n='场景理解 20% → 视觉检测 25%' }
    )
  }
  'cv2' = @{
    file = '功能点2：目标框选精细化解析.mp4'
    shots = @(
      @{ cam='dual';        ss=3.0;  d=1.6 },
      @{ cam='msg';         ss=4.6;  d=2.8 },
      @{ cam='think+zoom';  ss=7.8;  d=3.6 },
      @{ cam='think2';      ss=11.5; d=4.0 }
    )
    subs = @(
      @{ a=0.2;  b=1.6;  s='在画面上框一块';                  n='红框是人画的' },
      @{ a=1.8;  b=4.4;  s='再问：这些东西你认识吗？';        n='' },
      @{ a=4.6;  b=8.0;  s='它先把你框的那块切出来';          n='15% 图像预处理' },
      @{ a=8.2;  b=12.0; s='框里的东西，它有名字';            n='30% 识别 → 一排小图' }
    )
  }
  'cv3' = @{
    file = '功能点3：语义映射2-哨兵部署.mp4'
    shots = @(
      @{ cam='dual';        ss=5.2;  d=2.4 },
      @{ cam='msg';         ss=7.2;  d=2.8 },
      @{ cam='think';       ss=9.6;  d=3.2 },
      @{ cam='think2+zoom'; ss=12.4; d=3.6 }
    )
    subs = @(
      @{ a=0.2;  b=2.4;  s='它先自己写了一份日报';            n='食盆、如厕、建议' },
      @{ a=2.6;  b=5.2;  s='一句话，给它一条规则';            n='区域4 禁入就报警' },
      @{ a=5.4;  b=8.4;  s='它把这句话翻成坐标';              n='25% 区域绘制' },
      @{ a=8.6;  b=12.0; s='画面上多一个框，就是那条规则';    n='橙框＝刚布控的区域' }
    )
  }
  'cv4' = @{
    file = '功能点4：时序记录与智能报告生成.mp4'
    shots = @(
      @{ cam='dual';   ss=2.0;  d=2.4 },
      @{ cam='msg';    ss=3.4;  d=2.6 },
      @{ cam='think';  ss=6.5;  d=4.0 },
      @{ cam='think2'; ss=10.5; d=3.0 }
    )
    subs = @(
      @{ a=0.2;  b=2.4;  s='看一眼，答不了「今天正常吗」';    n='' },
      @{ a=2.6;  b=5.0;  s='它得回头翻 12 小时';              n='8:00–20:00 / 15fps' },
      @{ a=5.2;  b=9.0;  s='阈值全写在明面上';                n='80% / 70% / 60%、30 秒、5 分钟' },
      @{ a=9.2;  b=12.0; s='结论落在要不要动手';              n='建议清砂盆' }
    )
  }
}

function Write-Ass($path, $subs, $total) {
  $sb = New-Object Text.StringBuilder
  [void]$sb.AppendLine('[Script Info]')
  [void]$sb.AppendLine('ScriptType: v4.00+')
  [void]$sb.AppendLine('PlayResX: 1920')
  [void]$sb.AppendLine('PlayResY: 1080')
  [void]$sb.AppendLine('WrapStyle: 2')
  [void]$sb.AppendLine('ScaledBorderAndShadow: yes')
  [void]$sb.AppendLine('YCbCr Matrix: TV.709')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('[V4+ Styles]')
  [void]$sb.AppendLine('Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding')
  [void]$sb.AppendLine('Style: Band,Microsoft YaHei,20,&H00120F0F,&H00120F0F,&H00120F0F,&H00000000,0,0,0,0,100,100,0,0,1,0,0,7,0,0,0,1')
  [void]$sb.AppendLine('Style: Sub,Microsoft YaHei,64,&H00F1F5F2,&H00F1F5F2,&H000D0D0D,&H00000000,-1,0,0,0,100,100,0,0,1,0,0,1,0,0,0,1')
  [void]$sb.AppendLine('Style: Note,Microsoft YaHei,36,&H00A8B09F,&H00A8B09F,&H000D0D0D,&H00000000,0,0,0,0,100,100,0,0,1,0,0,3,0,0,0,1')
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine('[Events]')
  [void]$sb.AppendLine('Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text')
  [void]$sb.AppendLine(('Dialogue: 0,0:00:00.00,{0},Band,,0,0,0,,{{\an7\pos(0,896)\p1\bord0\shad0}}m 0 0 l 1920 0 l 1920 184 l 0 184' -f (Fmt $total)))
  foreach ($x in $subs) {
    [void]$sb.AppendLine(('Dialogue: 1,{0},{1},Sub,,0,0,0,,{{\pos(300,1006)\fad(180,180)}}{2}' -f (Fmt $x.a), (Fmt $x.b), $x.s))
    if ($x.n -and $x.n.Length -gt 0) {
      [void]$sb.AppendLine(('Dialogue: 1,{0},{1},Note,,0,0,0,,{{\pos(1880,1000)\fad(180,180)}}{2}' -f (Fmt $x.a), (Fmt $x.b), $x.n))
    }
  }
  [IO.File]::WriteAllText($path, $sb.ToString(), (New-Object Text.UTF8Encoding($true)))
}

function Fmt($t) {
  $h = [int][Math]::Floor($t / 3600); $m = [int][Math]::Floor(($t % 3600) / 60)
  $s = [Math]::Floor($t % 60); $cs = [int][Math]::Round(($t - [Math]::Floor($t)) * 100)
  if ($cs -eq 100) { $cs = 99 }
  return ('{0}:{1:00}:{2:00}.{3:00}' -f $h, $m, [int]$s, $cs)
}

foreach ($key in $PLAN.Keys) {
  if ($Only -and $key -ne $Only) { continue }
  $p = $PLAN[$key]
  $srcFile = Join-Path $SRC $p.file
  if (-not (Test-Path $srcFile)) { Write-Host "MISS $srcFile"; continue }
  Write-Host "=== $key ==="

  $i = 0
  $list = Join-Path $SEG "$key-list.txt"
  $lines = @()
  foreach ($sh in $p.shots) {
    $i++
    $c = $CAM[$sh.cam]
    $segOut = Join-Path $SEG ('{0}-{1}.mp4' -f $key, $i)
    if ($c.r) {
      $fc = "[0:v]split=2[a][b];[a]crop=$($c.l),scale=$($c.ls):flags=lanczos,setsar=1[l];[b]crop=$($c.r),scale=$($c.rs):flags=lanczos,setsar=1[r];color=c=0x0E2422:s=1920x1080:r=30:d=$($sh.d)[bg];[bg][l]overlay=$($c.lx):$($c.ly):shortest=1[x];[x][r]overlay=$($c.rx):$($c.ry):shortest=1[v]"
    } else {
      $fc = "[0:v]crop=$($c.l),scale=$($c.ls):flags=lanczos,setsar=1[c];color=c=0x0E2422:s=1920x1080:r=30:d=$($sh.d)[bg];[bg][c]overlay=$($c.lx):$($c.ly):shortest=1[v]"
    }    & $FF -hide_banner -loglevel error -ss $sh.ss -t $sh.d -i $srcFile `
      -filter_complex $fc -map '[v]' -an -r 30 -c:v libx264 -preset veryfast -crf 20 -pix_fmt yuv420p -y $segOut
    if ($LASTEXITCODE -ne 0) { Write-Host "  seg $i FAILED"; }
    $lines += "file '$($segOut -replace '\\','/')'"
  }
  [IO.File]::WriteAllLines($list, $lines)

  $silent = Join-Path $SEG "$key-silent.mp4"
  & $FF -hide_banner -loglevel error -f concat -safe 0 -i $list -c copy -y $silent
  if ($LASTEXITCODE -ne 0) { Write-Host "  concat FAILED"; continue }

  $assPath = Join-Path $ASSD "$key.ass"
  Write-Ass $assPath $p.subs 12.0
  $final = Join-Path $OUTD "$key.mp4"
  $assFilter = "ass=$key.ass"
  Push-Location $ASSD
  & $FF -hide_banner -loglevel error -i $silent -vf $assFilter -c:v libx264 -preset veryfast -crf 20 -pix_fmt yuv420p -movflags +faststart -y $final
  Pop-Location
  if ($LASTEXITCODE -ne 0) { Write-Host "  burn FAILED"; continue }
  $sz = [Math]::Round((Get-Item $final).Length / 1KB)
  Write-Host "  -> $key.mp4  ${sz} KB"
}
Write-Host 'done'
