$ErrorActionPreference='Stop'
$ff='E:\个人\个人学习-AI产品经理\_browse\node_modules\@ffmpeg-installer\win32-x64\ffmpeg.exe'
$SRCDIR='E:\个人\个人学习-AI产品经理\08-原型素材\CV+多模态'
$OUT='E:\个人\个人学习-AI产品经理\10-个人网站'
$ASSD='C:\Users\MeeCreeps\_v\ass'
$MASK='C:\Users\MeeCreeps\_cv\hole_dual.png'
$TMP='C:\Users\MeeCreeps\_cv\push'

$CLIPS=@(
  @{ k='cv1'; f='功能点1：全场景动态感知解析.mp4'; ss=0.5;  vs=22 },
  @{ k='cv2'; f='功能点2：目标框选精细化解析.mp4'; ss=3.0;  vs=24 },
  @{ k='cv3'; f='功能点3：语义映射2-哨兵部署.mp4';  ss=5.2;  vs=24 },
  @{ k='cv4'; f='功能点4：时序记录与智能报告生成.mp4';  ss=2.0;  vs=22 }
)
New-Item -ItemType Directory -Force -Path $TMP | Out-Null

foreach($c in $CLIPS){
  $k=$c.k; $src=Join-Path $SRCDIR $c.f
  if(-not (Test-Path $src)){ "MISSING $src"; continue }
  $Y="min(300+$($c.vs)*t\,583)"
  $fc = "[0:v]crop=1728:968:0:112,scale=1920:1080,eq=brightness=-0.05:saturation=0.94[base];" +
        "[base][1:v]overlay=0:0[dim];" +
        "[0:v]crop=w=735:h=497:x=135:y='$Y',scale=830:560[f1];" +
        "[0:v]crop=w=757:h=426:x=919:y=216,scale=700:394[f2];" +
        "[f1]pad=852:582:11:11:color=0x00000000,format=rgba[m1];" +
        "[dim][m1]overlay=59:49:format=auto[s1];" +
        "[f2]pad=722:416:11:11:color=0x00000000,format=rgba[m2];" +
        "[s1][m2]overlay=949:49:format=auto[out]"
  $raw=Join-Path $TMP "$k-raw.mp4"
  & $ff -hide_banner -loglevel error -ss $c.ss -t 12 -i $src -loop 1 -t 12 -i $MASK -filter_complex $fc -map "[out]" -r 30 -c:v libx264 -crf 20 -pix_fmt yuv420p -y $raw
  Push-Location $ASSD
  $final=Join-Path $OUT "$k.mp4"
  & $ff -hide_banner -loglevel error -i $raw -vf "ass=$k.ass" -c:v libx264 -crf 20 -pix_fmt yuv420p -r 30 -movflags +faststart -y $final
  Pop-Location
  if(Test-Path $final){ "  -> $k.mp4  " + [math]::Round((Get-Item $final).Length/1KB) + " KB" } else { "  !! $k failed" }
  # 海报从源抽（原始浅色界面，不要遮罩灰底）
  & $ff -hide_banner -loglevel error -ss ($c.ss + 5.6) -i $src -frames:v 1 -vf "crop=1728:968:0:112,scale=960:-2" -q:v 3 -y (Join-Path $OUT "$k.jpg")
}