# 部署：把这个站发给 HR

目标：给一个链接，点开就是完整体验（含视频），手机上也不变形。

---

## 方案对比

| | 成本 | 国内打开 | 微信里点开 | 上手工时 |
|---|---|---|---|---|
| **A. GitHub Pages** | 免费 | 能开，1–3 秒 | **能** | 10 分钟 |
| B. Cloudflare Pages / Vercel | 免费 | 时好时坏 | 经常打不开 | 5 分钟 |
| C. 买域名 + 国内对象存储 | 域名 ~50 元/年 + ICP 备案 | 快 | 能 | 2–3 周 |
| D. 直接发 zip | 免费 | — | 微信里打不开 HTML | 5 分钟 |

**结论：先上 A。** 链接一给就能用；只有当你确定要长期挂着、且在意那 1–2 秒的首屏时，才值得走 C（备案要 2–3 周，不急不要提前做）。

B 的问题很实在：HR 在微信里点开是白屏，你就失去了这次机会。所以 B 只适合做海外备份，不适合当主链接。

---

## A. GitHub Pages（推荐）

### 1. 建仓库

GitHub 上新建 **Public** 仓库，命名随意（建议 `portfolio`）。不要勾「Add README」。

### 2. 本地初始化并推上去

在 `10-个人网站` 目录里执行（把 `你的用户名` 换成实际账号）：

```powershell
git init
git add -A
git commit -m "portfolio"
git branch -M main
git remote add origin https://github.com/你的用户名/portfolio.git
git push -u origin main
```

### 3. 开 Pages

仓库 → **Settings → Pages** → Source 选 `Deploy from a branch` → Branch 选 `main` / 目录 `/ (root)` → Save。

等 1–2 分钟，地址是：

```
https://你的用户名.github.io/portfolio/
```

### 4. 改掉 og:image 里的占位

`index.html` 里搜 `你的域名`，把两处换成上面这个地址：

```html
<meta property="og:image" content="https://你的用户名.github.io/portfolio/share.jpg" />
<meta property="og:url"   content="https://你的用户名.github.io/portfolio/" />
```

改完 `git add -A && git commit -m "og" && git push`。

### 5. 验证

- 手机浏览器打开，滑动看四张卡是否 16:9、流程图是否点亮。
- 微信里发给自己，看卡片有没有标题和图。
- 点开任意一个视频，能播放、能拖进度条。

---

## C. 自有域名（确定要长期用时再看）

需要三样东西：域名、国内服务器或对象存储、ICP 备案。

1. 买域名（阿里云 / 腾讯云，`.com` 约 50–70 元/年，`.cn` 需实名）。
2. 对象存储开静态网站托管：阿里云 OSS 或腾讯云 COS，绑自定义域名。
3. ICP 备案：需要国内主体（个人身份证可），周期 2–3 周。
4. CNAME 指过去，开 HTTPS。

注意：**OSS / COS 的默认域名不能直接浏览 HTML**（会强制下载），必须绑自己的域名，所以绕不开备案。

---

## 配套的三件事

### 1. 分享卡（已做）

`share.jpg` 1200×630，链接发到微信 / 飞书 / Slack 会显示成一张卡片，而不是一条光秃秃的链接。

### 2. 视频体积

现在 19 MB，但**首屏不加载视频**——每段视频只有一张海报（几十 KB），点了才拉 mp4。首屏实际下载约 200 KB。

GitHub Pages 单文件限制 100 MB、仓库 1 GB，19 MB 很安全。

### 3. 要不要加访问统计

想大概知道有没有人打开，可以加一段不依赖第三方 JS 的：

```html
<img src="https://hits.sh/你的用户名.github.io/portfolio.svg" alt="" style="position:absolute;opacity:0">
```

不加也不影响使用。

---

## 备选：也给一份「不用打开网页」的版本

有些 HR 只收附件。建议同时准备：

1. **PDF**：浏览器打开站点 → Ctrl/Cmd + P → 存为 PDF（页面已做打印样式：视频换成海报、侧栏隐藏、动效关闭）。
2. **简历 docx**：`E:\云锦微\AI产品经理转型\胡迪个人简历-AI产品经理.docx`（记得先把海图 2026.03–2026.08、CAD 2026.05–2026.11 两处时间改成实际月份）。

发出去时一句带过：

> 网站：https://你的用户名.github.io/portfolio/
> 附件是同内容的 PDF，视频在网页里点开就能看。
