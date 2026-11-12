# 胡迪 · AI 产品经理

单页作品站。纯静态，无构建、无依赖，直接开 `index.html` 就能跑。

## 文件

| 文件 | 说明 |
|---|---|
| `index.html` | 全站（HTML + CSS + JS 单文件，约 80 KB） |
| `card-*.jpg` | 首屏四张界面卡（900 宽） |
| `a1–a4 / cad-review / factory-build .mp4` | 海图、审图、工厂六段演示 |
| `cv1–cv4.mp4` | 端侧感知四段演示 |
| `*.jpg` | 各视频的海报帧（无字幕，点击才加载视频） |
| `QC_code.jpg` | 微信二维码 |
| `share.jpg` | 社交分享卡 1200×630 |

## 本地预览

双击 `index.html`，或在目录里起个静态服务：

```powershell
python -m http.server 8080
# 打开 http://localhost:8080
```

## 部署

见 `DEPLOY.md`。

## 改内容时注意

- 数字都写在正文里，改一个数记得搜全文（首屏 `.stats`、各屏 `.nums`、`.judge` 里都有）。
- 视频换新版本后要重抽海报：`ffmpeg -ss <秒> -i x.mp4 -frames:v 1 -vf scale=960:-2 x.jpg`。
- 页面依赖 `--pine` / `--accent` 两个颜色变量，改主题色只动 `:root`。
