#!/bin/bash
set -e

VERSION="v0.2.0"
APP_NAME="X_for_mac"
DIST_DIR="$PWD/dist"
RELEASE_DIR="$PWD/release"

echo "🚀 Creating release package for $VERSION..."

# 1. Build the app
echo "📦 Building app..."
./build_package.sh

# 2. Create release directory
echo "📁 Creating release directory..."
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

# 3. Create ZIP archive
echo "🗜️  Creating ZIP archive..."
cd "$DIST_DIR"
zip -r "$RELEASE_DIR/${APP_NAME}-${VERSION}.zip" "${APP_NAME}.app"
cd - > /dev/null

# 4. Calculate checksum
echo "🔐 Calculating SHA256 checksum..."
cd "$RELEASE_DIR"
shasum -a 256 "${APP_NAME}-${VERSION}.zip" > "${APP_NAME}-${VERSION}.zip.sha256"
cd - > /dev/null

# 5. Create release notes
cat > "$RELEASE_DIR/release-notes.md" <<EOF
# X for Mac ${VERSION}

## 🎉 新功能

### 🌍 多语言支持
- 新增简体中文/英文界面切换
- 设置界面完整本地化
- 一键切换语言

### 🎨 布局控制
- **隐藏左侧栏** - 移除左侧导航菜单
- **隐藏右侧栏** - 移除右侧推荐区域
- **中间全屏模式** - 让内容填满窗口
  - 自定义宽度（600-3000px）
  - 🆕 **自适应窗口** - 根据窗口大小自动调整宽度
  - 实时响应窗口拖动

### ⚡ 增强功能
- 启用双指缩放手势（触控板/触摸板）
- 优化 Clean UI 实现（MutationObserver + SVG 路径检测）
- 改进 Google 登录拦截

### 🗑️ 移除功能
- 删除已废弃的"隐藏已认证组织"功能
- 删除已废弃的"隐藏屏蔽通知"功能

## 📦 安装说明

### macOS 14.0+ 系统要求

1. **下载并解压**
   \`\`\`bash
   unzip ${APP_NAME}-${VERSION}.zip
   \`\`\`

2. **移动到应用程序文件夹**
   \`\`\`bash
   mv X_for_mac.app /Applications/
   \`\`\`

3. **首次打开**
   
   由于应用未经 Apple 公证，首次打开时需要：
   
   - 右键点击应用 → 选择"打开"
   - 或在"系统偏好设置 → 隐私与安全性"中允许打开
   - 或使用命令：
     \`\`\`bash
     xattr -cr /Applications/X_for_mac.app
     open /Applications/X_for_mac.app
     \`\`\`

## ✅ 校验文件完整性

\`\`\`bash
shasum -a 256 -c ${APP_NAME}-${VERSION}.zip.sha256
\`\`\`

## 🐛 已知问题

- Google 登录被禁用（设计如此）
- 首次打开需要手动允许（未签名应用）

## 📝 完整更新日志

查看 [README.md](https://github.com/ShiKeQuan/X_for_Mac) 了解所有功能详情。

---

**如果遇到问题，请在 [Issues](https://github.com/ShiKeQuan/X_for_Mac/issues) 中反馈。**
EOF

# 6. Summary
echo ""
echo "✅ Release package created successfully!"
echo ""
echo "📦 Files created:"
ls -lh "$RELEASE_DIR"
echo ""
echo "📋 Next steps:"
echo "1. Go to: https://github.com/ShiKeQuan/X_for_Mac/releases/new"
echo "2. Tag: ${VERSION}"
echo "3. Title: X for Mac ${VERSION}"
echo "4. Upload files:"
echo "   - ${APP_NAME}-${VERSION}.zip"
echo "   - ${APP_NAME}-${VERSION}.zip.sha256"
echo "5. Copy release notes from: release/release-notes.md"
echo ""
