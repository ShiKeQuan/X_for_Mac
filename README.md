# X for Mac

> 一个轻量级的 macOS 桌面应用，为 X (Twitter) 提供原生窗口体验

## 📸 应用截图

### 原始界面
<img src="screenshots/原界面.png" width="800" alt="原始界面">

### 隐藏图标界面
<img src="screenshots/隐藏图标界面.png" width="800" alt="隐藏不必要的界面元素">

### 开启全屏界面
<img src="screenshots/开启全屏界面.png" width="800" alt="中间全屏模式">

### 功能设置面板
<div>
  <img src="screenshots/功能界面1.png" width="400" alt="设置面板1">
  <img src="screenshots/功能界面2.png" width="400" alt="设置面板2">
</div>

## ✨ 特性

### 🎯 核心功能
- **独立应用窗口** - 在独立的 macOS 应用中运行 X，无需浏览器
- **原生体验** - 使用 SwiftUI + WKWebView 构建，完美融入 macOS
- **会话保持** - 自动保存登录状态，无需重复登录
- **深度链接** - 从其他应用打开的 x.com 链接自动跳转到本应用
- **键盘快捷键** - 支持 Cmd+[/] 前进后退、Cmd+R 刷新、Cmd+Shift+H 回到主页

### 🛡️ 安全特性
- **Google 登录拦截** - 自动屏蔽 Google SSO，避免隐私泄露
- **外链保护** - 非 X 域名链接自动在系统浏览器打开
- **沙盒隔离** - 完全沙盒化，保护系统安全

### 🎨 界面优化 (Clean UI)

#### 隐藏元素
- ✅ 隐藏 Grok（使用 SVG 路径检测）
- ✅ 隐藏高级订阅推广
- ✅ 隐藏订阅卡片
- ✅ 隐藏其他推广（工作、商业、广告）
- ✅ 导航栏控制：探索、通知、私信、社区、书签

#### 布局控制 ⭐️
- **隐藏右侧栏** - 移除右侧推荐区域
- **隐藏左侧栏** - 移除左侧导航菜单
- **中间全屏模式** 
  - 自动隐藏左右两栏，内容居中显示
  - 📏 自定义宽度（600-3000px，默认 1200px）
  - 🔄 **自适应窗口** - 根据窗口大小自动调整宽度
  - 实时响应窗口拖动
  - 智能最大宽度限制
- **自定义边距** - 调整内容区域的右侧边距

### 🌍 多语言支持
- 🇨🇳 简体中文
- 🇺🇸 English
- 设置界面完整本地化
- 一键切换语言

### ⚙️ 其他功能
- **登录时启动** - 开机自动启动应用
- **自定义启动页** - 选择主页/正在关注/为你推荐
- **双指缩放** - 支持触控板双指缩放手势

## 📦 安装

### 从源码编译

#### 要求
- macOS 14.0+
- Xcode 15.0+
- Swift 5.9+

#### 步骤
```bash
# 克隆仓库
git clone https://github.com/ShiKeQuan/X_for_Mac.git
cd X_for_Mac

# 编译并打包
./build_package.sh

# 应用会自动打开，或手动打开
open dist/X_for_mac.app
```

### 安装到应用程序文件夹
```bash
cp -r dist/X_for_mac.app /Applications/
```

## 🎮 使用方法

### 首次使用
1. 打开应用，自动加载 X 登录页面
2. 使用邮箱/密码登录（不支持 Google 登录）
3. 打开设置（工具栏齿轮图标）配置偏好

### 界面优化设置
1. 点击工具栏右侧的 ⚙️ 图标
2. 在"界面优化"部分选择要隐藏的元素
3. 在"布局"部分启用全屏模式：
   - 勾选 **中间全屏**
   - 勾选 **自适应窗口** 可跟随窗口大小自动调整
   - 或手动设置 **最大宽度** 值
4. 设置自动保存，刷新页面生效

### 键盘快捷键
- `Cmd + [` - 后退
- `Cmd + ]` - 前进
- `Cmd + R` - 刷新
- `Cmd + Shift + H` - 回到主页
- `Cmd + ,` - 打开设置

## 🛠️ 技术架构

### 核心技术栈
- **SwiftUI** - 原生 UI 框架
- **WKWebView** - WebKit 浏览器引擎
- **WKUserScript** - JavaScript 注入
- **MutationObserver** - 动态 DOM 监控
- **SMAppService** - 登录时启动

### Clean UI 实现原理
```swift
// 1. CSS 规则注入
cssRules.append("header[role='banner'] { display: none !important; }")

// 2. MutationObserver 监控动态内容
const observer = new MutationObserver(() => {
    document.querySelectorAll('selector').forEach(el => el.remove());
});

// 3. SVG 路径匹配（用于图标识别）
const path = svg.querySelector('path');
if (path.getAttribute('d') === targetPathD) {
    container.remove();
}

// 4. 自适应窗口宽度
window.addEventListener('resize', () => {
    const width = Math.min(window.innerWidth - 40, maxWidth);
    document.documentElement.style.setProperty('--dynamic-width', width + 'px');
});
```

## 📂 项目结构

```
X_for_mac/
├── Sources/X_for_mac/
│   ├── X_for_mac.swift          # 应用入口
│   ├── Models/
│   │   ├── PreferencesStore.swift   # 设置存储和脚本生成
│   │   └── WebViewModel.swift       # WebView 状态管理
│   ├── Views/
│   │   ├── WebView.swift           # WKWebView 封装
│   │   ├── ContentView.swift       # 主界面
│   │   └── PreferencesView.swift   # 设置面板
│   ├── Localization/
│   │   └── Localizable.swift       # 多语言支持
│   └── Utilities/
│       ├── AppMenuCommands.swift    # 菜单命令
│       └── LaunchOnLoginManager.swift
├── Package.swift
├── build_package.sh             # 打包脚本
└── README.md
```

## 🔧 开发

### 构建发布版本
```bash
swift build -c release
./build_package.sh
```

### 调试
```bash
swift build
open .build/debug/X_for_mac
```

### 修改 Clean UI 规则
编辑 `Sources/X_for_mac/Models/PreferencesStore.swift` 中的 `makeCleanUIScript()` 函数。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 开发建议
- 遵循 Swift 代码规范
- 添加新功能时更新相应的本地化字符串
- 测试所有语言版本
- 更新 README 文档

## 📄 许可证

MIT License

## 🙏 致谢

- 灵感来源：用户脚本 [X/Twitter Clean-up & Wide Layout Display](https://greasyfork.org/scripts/545419)
- SwiftUI 和 WebKit 框架

## 📮 联系方式

- GitHub: [@ShiKeQuan](https://github.com/ShiKeQuan)
- 仓库: [X_for_Mac](https://github.com/ShiKeQuan/X_for_Mac)

## 🐛 已知问题

- Google 登录被禁用（设计如此）
- 部分动态加载内容可能需要刷新页面
- 某些 X 更新可能导致 CSS 选择器失效（需要更新脚本）

## 📝 更新日志

### v0.2.0 (2024-12-24)
- ✨ 新增多语言支持（中文/英文）
- ✨ 新增布局控制：隐藏左侧栏、右侧栏
- ✨ 新增中间全屏模式（可自定义宽度）
- ✨ 新增自适应窗口宽度功能
- ✨ 启用双指缩放手势
- 🔧 删除已废弃功能（已认证组织、屏蔽通知）
- 🐛 修复 Clean UI 功能失效问题
- ⚡ 优化 MutationObserver 性能

### v0.1.0
- 🎉 初始版本
- ✅ 基础窗口和导航
- ✅ Google SSO 拦截
- ✅ 基础 Clean UI 功能

---

**如果这个项目对你有帮助，请给一个 ⭐️ Star！**
