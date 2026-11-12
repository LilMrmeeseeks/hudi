$ErrorActionPreference='Stop'
$ff='E:\个人\个人学习-AI产品经理\_browse\node_modules\@ffmpeg-installer\win32-x64\ffmpeg.exe'
$b='E:\个人\个人学习-AI产品经理\10-个人网站\_video\build'
$out='E:\个人\个人学习-AI产品经理\10-个人网站\_video'
$w='C:\Users\MeeCreeps\_v'
New-Item -ItemType Directory -Force -Path $w | Out-Null

$jobs=@(
  @('a1','a1-base','a1-qa',13.0),
  @('a3','a3-base','a3-notice',10.5),
  @('a4','a4-base','a4-chart',17.0),
  @('cad','cad-base','cad-review',16.3),
  @('fac','fac-base','factory-build',17.34)
)

foreach($j in $jobs){
  $assN=$j[0]; $base=$j[1]; $name=$j[2]; $dur=$j[3]
  Copy-Item -LiteralPath "$b\$assN.ass" -Destination "$w\$assN.ass" -Force
  & $ff -hide_banner -loglevel error -i "$b\$base.mp4" -vf "ass='C\:/Users/MeeCreeps/_v/$assN.ass':fontsdir='C\:/Windows/Fonts'" -r 30 -c:v libx264 -crf 24 -preset slow -pix_fmt yuv420p -movflags +faststart -an -y "$out\$name.mp4" 2>&1
  if($LASTEXITCODE -ne 0){ throw "burn failed: $name" }
  $mb=(Get-Item "$out\$name.mp4").Length/1MB
  & $ff -hide_banner -loglevel error -ss 1.6 -i "$out\$name.mp4" -frames:v 1 -vf "scale=960:-2" -q:v 4 -y "$out\$name.jpg" 2>&1
  "{0,-18} {1,6:N2} MB   poster {2,5:N0} KB" -f "$name.mp4", $mb, ((Get-Item "$out\$name.jpg").Length/1KB)
}
'--- burned ---'