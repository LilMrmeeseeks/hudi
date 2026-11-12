$ErrorActionPreference='Stop'
$p='E:\个人\个人学习-AI产品经理\10-个人网站\index.html'
$t=[IO.File]::ReadAllText($p,[Text.Encoding]::UTF8)
$enc=New-Object Text.UTF8Encoding($false)

# ---------- 1. CSS ----------
$css=@'
.clips{display:grid; grid-template-columns:repeat(3,1fr); gap:14px; margin:28px 0 36px}
.clips.solo{grid-template-columns:minmax(0,880px)}
.clip{margin:0; border:1px solid var(--rule); background:#0B0F0E; overflow:hidden; break-inside:avoid}
.clip video{display:block; width:100%; height:auto; aspect-ratio:16/9; background:#0B0F0E}
.clip figcaption{padding:10px 13px; font-size:var(--t1); line-height:1.55; color:var(--ink-soft); background:var(--paper); border-top:1px solid var(--rule)}
@media (max-width:900px){ .clips{grid-template-columns:1fr} }
@media print{ .clip{border-color:#999} .clip video{display:none} .clip::before{content:"视频（打印略）"; display:block; padding:10px 13px; font-size:12px; color:#666} }
'@
$anchor='@media (max-width:900px){'
$idx=$t.IndexOf('.clips{display:grid')
if($idx -lt 0){
  $pos=$t.IndexOf('@media (max-width:900px)')
  if($pos -lt 0){ throw 'css anchor missing' }
  $t=$t.Insert($pos, $css + "`r`n")
} else { 'css already present' }

# ---------- 2. markup ----------
function Clip($name,$cap){
  @"
    <div class="clips">
      <figure class="clip">
        <video poster="$name.jpg" muted loop playsinline preload="none" aria-label="$cap">
          <source src="$name.mp4" type="video/mp4">
        </video>
        <figcaption>$cap</figcaption>
      </figure>
    </div>
"@
}

# chart: 三个
$chartClips=@'
    <div class="clips">
      <figure class="clip">
        <video poster="a1-qa.jpg" muted loop playsinline preload="none" aria-label="Agent 1 问答：问一句，回一张表加一段结论">
          <source src="a1-qa.mp4" type="video/mp4">
        </video>
        <figcaption>Agent 1 · 问答：问一句，回一张表加一段结论</figcaption>
      </figure>
      <figure class="clip">
        <video poster="a3-notice.jpg" muted loop playsinline preload="none" aria-label="Agent 3 航行通告：20 条先分四类，再给结论">
          <source src="a3-notice.mp4" type="video/mp4">
        </video>
        <figcaption>Agent 3 · 航行通告：20 条先分四类，再给结论</figcaption>
      </figure>
      <figure class="clip">
        <video poster="a4-chart.jpg" muted loop playsinline preload="none" aria-label="Agent 4 专题图：一句话出一张可下载的海图">
          <source src="a4-chart.mp4" type="video/mp4">
        </video>
        <figcaption>Agent 4 · 专题图：一句话出一张可下载的海图</figcaption>
      </figure>
    </div>

'@
if(-not $t.Contains('a1-qa.mp4')){
  $t=$t.Replace('<div class="trade-cap">', $chartClips + '<div class="trade-cap">')
} else {'chart clips already there'}

# cad: 一个，插在 todo-list 之前
if(-not $t.Contains('cad-review.mp4')){
  $cadClip=@'
    <div class="clips">
      <figure class="clip">
        <video poster="cad-review.jpg" muted loop playsinline preload="none" aria-label="审图工作台：三个 dwg，7 条规则，0 条被自动通过">
          <source src="cad-review.mp4" type="video/mp4">
        </video>
        <figcaption>审图工作台 · 三个 dwg 一次提交，7 条规则跑完，0 条被自动通过</figcaption>
      </figure>
    </div>

'@
  $t=$t.Replace('<div class="todo-list">', $cadClip + '<div class="todo-list">')
} else {'cad clip already there'}

# factory: 一个，插在 factory 段的 fig 之前
if(-not $t.Contains('factory-build.mp4')){
  $facClip=@'
    <div class="clips">
      <figure class="clip">
        <video poster="factory-build.jpg" muted loop playsinline preload="none" aria-label="Agent Factory：先说需求，它反问，再长出一个智能体">
          <source src="factory-build.mp4" type="video/mp4">
        </video>
        <figcaption>Agent Factory · 说需求 → 它反问 → 方案冻结 → 长出智能体 → 直接给结论</figcaption>
      </figure>
    </div>

'@
  $fi=$t.IndexOf('id="factory"')
  $fp=$t.IndexOf('<div class="fig">',$fi)
  if($fp -lt 0){ throw 'factory fig anchor missing' }
  $t=$t.Insert($fp, $facClip)
} else {'factory clip already there'}

# ---------- 3. JS ----------
if(-not $t.Contains("querySelectorAll('.clip video')")){
  $js=@'

  /* 演示视频：进视口才播，离开暂停；reduced-motion 只留 poster */
  var clipVids=[].slice.call(document.querySelectorAll('.clip video'));
  if(clipVids.length && !reduce && 'IntersectionObserver' in window){
    var vObs=new IntersectionObserver(function(es){
      es.forEach(function(e){
        var v=e.target;
        if(e.isIntersecting){ var pr=v.play(); if(pr&&pr.catch){ pr.catch(function(){}); } }
        else if(!v.paused){ v.pause(); }
      });
    },{threshold:0.25});
    clipVids.forEach(function(v){ vObs.observe(v); });
  }
'@
  $jt=$t.LastIndexOf('})();')
  if($jt -lt 0){ throw 'js iife end missing' }
  $t=$t.Insert($jt, $js)
} else {'js already there'}

[IO.File]::WriteAllText($p,$t,$enc)
"written, len=$($t.Length)"
'--- verify ---'
foreach($s in 'a1-qa.mp4','a3-notice.mp4','a4-chart.mp4','cad-review.mp4','factory-build.mp4','clipVids','.clips{display:grid'){
  "{0,-22} {1}" -f $s, $t.Contains($s)
}