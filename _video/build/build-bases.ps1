$ErrorActionPreference='Stop'
$ff='E:\个人\个人学习-AI产品经理\_browse\node_modules\@ffmpeg-installer\win32-x64\ffmpeg.exe'
$b='E:\个人\个人学习-AI产品经理\10-个人网站\_video\build'
New-Item -ItemType Directory -Force -Path $b | Out-Null
$P='E:\个人\个人学习-AI产品经理\08-原型素材\海图精灵-原型'
$C='E:\个人\个人学习-AI产品经理\08-原型素材\人防CAD'
$F='E:\云锦微\2、云锦微网页素材\网站改版-5\test\viitrix-kimi-2.0-副本\7.0\videos'

function Seg($src,$ss,$t,$filt,$out){
  & $ff -hide_banner -loglevel error -ss $ss -t $t -i $src -vf $filt -r 30 -c:v libx264 -crf 18 -pix_fmt yuv420p -an -y "$b\$out" 2>&1
  if($LASTEXITCODE -ne 0){ throw "seg failed: $out" }
  "{0,-14} {1,6:N2} MB" -f $out, ((Get-Item "$b\$out").Length/1MB)
}

$paperCrop='crop=1830:980:0:100,scale=1920:-2,pad=1920:1080:0:(oh-ih)/2:color=0xF6F7F4'
$paperFull='scale=1830:-2,pad=1920:1080:0:(oh-ih)/2:color=0xF6F7F4'
$cadFit='scale=1920:-2,pad=1920:1080:0:(oh-ih)/2:color=0x0E2422'
$facFit='scale=-2:1080,pad=1920:1080:(ow-iw)/2:0:color=0x0A0D0C'

Seg "$P\Agent1-问答\Agent1-问答.mp4" 32 13 $paperCrop 'a1-base.mp4'
Seg "$P\Agent3-航行通警告\Agent3-航行通警告.mp4" 0 10.5 $paperCrop 'a3-base.mp4'
Seg "$P\Agent4-制图智能体\Agent4-制图智能体.mp4" 0 9 $paperCrop 'a4-p1.mp4'
Seg "$P\Agent4-制图智能体\Agent4-制图智能体.mp4" 22.5 8 $paperCrop 'a4-p2.mp4'
& $ff -hide_banner -loglevel error -i "$b\a4-p1.mp4" -vf "fade=t=out:st=8.7:d=0.3:color=0xF6F7F4" -r 30 -c:v libx264 -crf 18 -pix_fmt yuv420p -an -y "$b\a4-p1f.mp4" 2>&1
& $ff -hide_banner -loglevel error -i "$b\a4-p2.mp4" -vf "fade=t=in:st=0:d=0.3:color=0xF6F7F4" -r 30 -c:v libx264 -crf 18 -pix_fmt yuv420p -an -y "$b\a4-p2f.mp4" 2>&1
$al="$b\a4-list.txt"; if(Test-Path $al){Remove-Item $al}
Add-Content -Path $al -Value ("file '{0}/a4-p1f.mp4'" -f ($b -replace '\\','/'))
Add-Content -Path $al -Value ("file '{0}/a4-p2f.mp4'" -f ($b -replace '\\','/'))
& $ff -hide_banner -loglevel error -f concat -safe 0 -i $al -c copy -y "$b\a4-base.mp4" 2>&1
"a4-base        {0:N2} MB" -f ((Get-Item "$b\a4-base.mp4").Length/1MB)

$cadSegs=@(@(12,0.8),@(15,2.5),@(18,1),@(26,3),@(36,3),@(40,6))
$list="$b\cad-list.txt"; if(Test-Path $list){Remove-Item $list}
$i=0
foreach($s in $cadSegs){
  $i++
  Seg "$C\CAD审图演示素材.mp4" $s[0] $s[1] $cadFit ("cad-s{0}.mp4" -f $i)
  Add-Content -Path $list -Value ("file '{0}/cad-s{1}.mp4'" -f ($b -replace '\\','/'), $i)
}
& $ff -hide_banner -loglevel error -f concat -safe 0 -i $list -c copy -y "$b\cad-base.mp4" 2>&1
"cad-base       {0:N2} MB" -f ((Get-Item "$b\cad-base.mp4").Length/1MB)

$facSrc=@('02-ask.mp4','03-pick.mp4','04-build.mp4','05-run.mp4')
$flist="$b\fac-list.txt"; if(Test-Path $flist){Remove-Item $flist}
$i=0
foreach($vfile in $facSrc){
  $i++
  Seg "$F\$vfile" 0 30 $facFit ("fac-s{0}.mp4" -f $i)
  Add-Content -Path $flist -Value ("file '{0}/fac-s{1}.mp4'" -f ($b -replace '\\','/'), $i)
}
& $ff -hide_banner -loglevel error -f concat -safe 0 -i $flist -c copy -y "$b\fac-base.mp4" 2>&1
"fac-base       {0:N2} MB" -f ((Get-Item "$b\fac-base.mp4").Length/1MB)
'--- done ---'