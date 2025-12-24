# 发布指南

## 📦 创建发布包

运行发布脚本：
```bash
./create_release.sh
```

这会自动完成：
1. ✅ 编译最新版本
2. ✅ 打包应用
3. ✅ 创建 ZIP 压缩包
4. ✅ 生成 SHA256 校验文件
5. ✅ 生成发布说明

## 📤 发布到 GitHub

### 方法一：通过 GitHub 网页（推荐）

1. **访问 Release 页面**
   ```
   https://github.com/ShiKeQuan/X_for_Mac/releases/new
   ```

2. **填写信息**
   - **Tag**: `v0.2.0`（点击"Create new tag"）
   - **Target**: `main` 分支
   - **Title**: `X for Mac v0.2.0`

3. **上传文件**
   
   将以下文件拖拽到附件区域：
   - `release/X_for_mac-v0.2.0.zip` (约 246KB)
   - `release/X_for_mac-v0.2.0.zip.sha256` (87B)

4. **复制发布说明**
   
   复制 `release/release-notes.md` 的内容到描述框

5. **发布**
   
   - 勾选 `Set as the latest release`
   - 如果是预览版可以勾选 `Set as a pre-release`
   - 点击 `Publish release`

### 方法二：使用 GitHub CLI（可选）

```bash
# 安装 GitHub CLI（如果还没有）
brew install gh

# 登录
gh auth login

# 创建 Release
cd /Users/kequan/Desktop/Test/X_for_mac
gh release create v0.2.0 \
  release/X_for_mac-v0.2.0.zip \
  release/X_for_mac-v0.2.0.zip.sha256 \
  --title "X for Mac v0.2.0" \
  --notes-file release/release-notes.md
```

## 🔄 更新版本号

下次发布时修改 `create_release.sh` 中的版本号：
```bash
VERSION="v0.3.0"  # 更新这里
```

同时更新：
- `build_package.sh` 中的 `CFBundleShortVersionString` 和 `CFBundleVersion`
- `README.md` 中的更新日志

## 📝 发布检查清单

发布前确认：
- [ ] 所有代码已提交并推送
- [ ] 版本号已更新
- [ ] 功能已测试
- [ ] 文档已更新（README.md, plan.md）
- [ ] 更新日志已编写
- [ ] 构建成功无错误
- [ ] 应用图标正确显示

## 🎯 用户下载后的使用说明

用户需要：

1. **下载 ZIP 文件**
2. **解压**：双击 ZIP 文件
3. **移动到应用程序**：拖动到 `/Applications/` 文件夹
4. **首次打开**：右键点击 → "打开"（或运行 `xattr -cr` 命令）

由于应用未经 Apple Developer 签名，macOS Gatekeeper 会阻止直接打开。提供的说明已包含解决方法。

## 🔐 关于签名

### 当前状态
- 使用 ad-hoc 签名（`codesign --sign -`）
- 未经 Apple 公证
- 用户需要手动允许打开

### 升级方案（可选）
如果需要更好的用户体验：

1. **购买 Apple Developer 账号** ($99/年)
2. **使用 Developer ID 签名**
3. **提交公证** (notarization)

这样用户可以直接双击打开，无需额外步骤。

## 📊 发布后

发布后可以：
- 在 README 中添加下载徽章
- 分享到社交媒体
- 收集用户反馈
- 规划下一版本功能

---

**祝发布顺利！🚀**
