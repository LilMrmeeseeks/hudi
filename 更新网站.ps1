# 更新网站：改完内容双击这个文件就行
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

if (-not (Test-Path '.git')) {
    Write-Host '这里不是 git 仓库，先按 DEPLOY.md 做第一次推送。' -ForegroundColor Red
    Read-Host '按回车退出'
    exit
}

$dirty = git status --porcelain
if (-not $dirty) {
    Write-Host '没有改动，不用更新。' -ForegroundColor Yellow
    Read-Host '按回车退出'
    exit
}

Write-Host '即将更新的文件：' -ForegroundColor Cyan
git status --short
Write-Host ''

$msg = Read-Host '一句话说明改了什么（直接回车 = 自动用时间）'
if ([string]::IsNullOrWhiteSpace($msg)) {
    $msg = 'update ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')
}

git add -A
git commit -m $msg
Write-Host ''
Write-Host '正在推送到 GitHub…' -ForegroundColor Cyan
git push

$stamp = Get-Date -Format 'yyyyMMddHHmm'
Write-Host ''
Write-Host '已推送。1–2 分钟后线上生效。' -ForegroundColor Green
Write-Host '手机或微信里看到的还是旧版，就打开下面这个带时间戳的地址强制刷新：' -ForegroundColor DarkGray
Write-Host "  https://你的用户名.github.io/portfolio/?v=$stamp"
Write-Host ''
Read-Host '按回车退出'
