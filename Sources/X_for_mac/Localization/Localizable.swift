import Foundation

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case chinese = "zh-CN"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .chinese: return "简体中文"
        }
    }
}

struct LocalizedStrings {
    let language: Language
    
    // MARK: - General
    var appName: String {
        switch language {
        case .english: return "X for Mac"
        case .chinese: return "X for Mac"
        }
    }
    
    // MARK: - Preferences Window
    var preferences: String {
        switch language {
        case .english: return "Preferences"
        case .chinese: return "设置"
        }
    }
    
    var general: String {
        switch language {
        case .english: return "General"
        case .chinese: return "通用"
        }
    }
    
    var languageLabel: String {
        switch language {
        case .english: return "Language"
        case .chinese: return "语言"
        }
    }
    
    var startPage: String {
        switch language {
        case .english: return "Start Page"
        case .chinese: return "启动页面"
        }
    }
    
    var home: String {
        switch language {
        case .english: return "Home"
        case .chinese: return "主页"
        }
    }
    
    var following: String {
        switch language {
        case .english: return "Following"
        case .chinese: return "正在关注"
        }
    }
    
    var forYou: String {
        switch language {
        case .english: return "For You"
        case .chinese: return "为你推荐"
        }
    }
    
    var launchOnLogin: String {
        switch language {
        case .english: return "Launch on Login"
        case .chinese: return "登录时启动"
        }
    }
    
    // MARK: - Clean UI Section
    var cleanUI: String {
        switch language {
        case .english: return "Clean UI"
        case .chinese: return "界面优化"
        }
    }
    
    var hideElements: String {
        switch language {
        case .english: return "Hide Elements"
        case .chinese: return "隐藏元素"
        }
    }
    
    var hideGrok: String {
        switch language {
        case .english: return "Hide Grok"
        case .chinese: return "隐藏 Grok"
        }
    }
    
    var hidePremium: String {
        switch language {
        case .english: return "Hide Premium Sign Up"
        case .chinese: return "隐藏高级订阅"
        }
    }
    
    var hideSelectors: String {
        switch language {
        case .english: return "Hide Subscribe Cards"
        case .chinese: return "隐藏订阅卡片"
        }
    }
    
    var hideOther: String {
        switch language {
        case .english: return "Hide Other Promotions"
        case .chinese: return "隐藏其他推广"
        }
    }
    
    var navigation: String {
        switch language {
        case .english: return "Navigation"
        case .chinese: return "导航栏"
        }
    }
    
    var hideExplore: String {
        switch language {
        case .english: return "Hide Explore"
        case .chinese: return "隐藏探索"
        }
    }
    
    var hideNotifications: String {
        switch language {
        case .english: return "Hide Notifications"
        case .chinese: return "隐藏通知"
        }
    }
    
    var hideMessages: String {
        switch language {
        case .english: return "Hide Messages"
        case .chinese: return "隐藏私信"
        }
    }
    
    var hideCommunities: String {
        switch language {
        case .english: return "Hide Communities"
        case .chinese: return "隐藏社区"
        }
    }
    
    var hideBookmarks: String {
        switch language {
        case .english: return "Hide Bookmarks"
        case .chinese: return "隐藏书签"
        }
    }
    
    var layout: String {
        switch language {
        case .english: return "Layout"
        case .chinese: return "布局"
        }
    }
    
    var hideRightColumn: String {
        switch language {
        case .english: return "Hide Right Column"
        case .chinese: return "隐藏右侧栏"
        }
    }
    
    var hideLeftbar: String {
        switch language {
        case .english: return "Hide Left Sidebar"
        case .chinese: return "隐藏左侧栏"
        }
    }
    
    var fillCenter: String {
        switch language {
        case .english: return "Full Width Center"
        case .chinese: return "中间全屏"
        }
    }
    
    var autoResize: String {
        switch language {
        case .english: return "Auto-resize to Window"
        case .chinese: return "自适应窗口"
        }
    }
    
    var centerWidth: String {
        switch language {
        case .english: return "Max Width"
        case .chinese: return "最大宽度"
        }
    }
    
    var width: String {
        switch language {
        case .english: return "Width"
        case .chinese: return "宽度"
        }
    }
    
    var customPadding: String {
        switch language {
        case .english: return "Use Custom Padding"
        case .chinese: return "使用自定义边距"
        }
    }
    
    var padding: String {
        switch language {
        case .english: return "Padding"
        case .chinese: return "边距"
        }
    }
    
    var px: String {
        switch language {
        case .english: return "px"
        case .chinese: return "像素"
        }
    }
    
    // MARK: - Alerts
    var googleLoginBlocked: String {
        switch language {
        case .english: return "Google login is disabled in this app. Please use email/password or complete login in your browser."
        case .chinese: return "Google 登录已在此应用禁用，请使用邮箱/密码或在浏览器完成。"
        }
    }
}

extension PreferencesStore {
    var localizedStrings: LocalizedStrings {
        let lang = Language(rawValue: language) ?? .chinese
        return LocalizedStrings(language: lang)
    }
}
