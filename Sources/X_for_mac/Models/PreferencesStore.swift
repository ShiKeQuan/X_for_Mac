import Foundation
import Combine

final class PreferencesStore: ObservableObject {
    @Published var language: String {
        didSet {
            persistLanguage()
        }
    }
    
    @Published var startPageText: String {
        didSet {
            persistStartPage()
        }
    }

    @Published var launchAtLogin: Bool {
        didSet {
            persistLaunchAtLogin()
        }
    }

    @Published var cleanUISettings: CleanUISettings {
        didSet {
            persistCleanUISettings()
            cleanUIRevision &+= 1
        }
    }

    @Published private(set) var cleanUIRevision: Int = 0

    private let defaults: UserDefaults
    private let languageKey = "language"
    private let startPageKey = "startPageURL"
    private let launchOnLoginKey = "launchOnLogin"
    private let cleanUIKey = "cleanUISettings"
    private let defaultStartPage = "https://x.com/home"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.language = defaults.string(forKey: languageKey) ?? "zh-CN"
        self.startPageText = defaults.string(forKey: startPageKey) ?? defaultStartPage
        self.launchAtLogin = defaults.object(forKey: launchOnLoginKey) as? Bool ?? false
        if let data = defaults.data(forKey: cleanUIKey),
           let decoded = try? JSONDecoder().decode(CleanUISettings.self, from: data) {
            self.cleanUISettings = decoded
        } else {
            self.cleanUISettings = .defaults
        }
    }

    var startPageURL: URL {
        guard let url = normalizedURL(from: startPageText), isXHost(url) else {
            return URL(string: defaultStartPage)!
        }
        return url
    }

    private func persistStartPage() {
        defaults.set(startPageText, forKey: startPageKey)
    }
    
    private func persistLanguage() {
        defaults.set(language, forKey: languageKey)
    }

    private func persistLaunchAtLogin() {
        defaults.set(launchAtLogin, forKey: launchOnLoginKey)
        do {
            try LaunchOnLoginManager.update(enabled: launchAtLogin)
        } catch {
            launchAtLogin = false
            defaults.set(false, forKey: launchOnLoginKey)
            NSLog("Launch on login update failed: \(error.localizedDescription)")
        }
    }

    private func normalizedURL(from string: String) -> URL? {
        if let url = URL(string: string), url.scheme != nil {
            return url
        }
        if let url = URL(string: "https://\(string)") {
            return url
        }
        return nil
    }

    private func isXHost(_ url: URL) -> Bool {
        guard let host = url.host?.lowercased() else { return false }
        return host.hasSuffix("x.com") || host.hasSuffix("twitter.com")
    }

    private func persistCleanUISettings() {
        if let data = try? JSONEncoder().encode(cleanUISettings) {
            defaults.set(data, forKey: cleanUIKey)
        }
    }

    func makeCleanUIScript() -> String {
        let s = cleanUISettings
        var cssRules: [String] = []
        
        // 基于 function.js 的实际选择器
        if s.hideGrok {
            cssRules.append("a[href='/i/grok'] { display: none !important; }")
            cssRules.append(".css-175oi2r.r-1867qdf.r-xnswec.r-13awgt0.r-1ce3o0f.r-1udh08x.r-u8s1d.r-13qz1uu.r-173mn98.r-1e5uvyk.r-ii8lfi.r-40lpo0.r-rs99b7.r-12jitg0 { display: none !important; }")
        }
        
        if s.hidePremiumSignUp {
            cssRules.append("a[href='/i/premium_sign_up'] { display: none !important; }")
        }
        
        if s.hideSelectors {
            cssRules.append(".css-175oi2r.r-1xpp3t0 { display: none !important; }")
            cssRules.append(".css-175oi2r.r-yfoy6g.r-18bvks7.r-1q9bdsx.r-rs99b7 { display: none !important; }")
            cssRules.append(".css-175oi2r.r-1habvwh.r-1ssbvtb.r-1mmae3n.r-3pj75a { display: none !important; }")
        }
        
        if s.hideOther {
            cssRules.append("a[href='/jobs'] { display: none !important; }")
            cssRules.append("a[href='/i/premium-business'] { display: none !important; }")
            cssRules.append("a[href='https://ads.twitter.com/?ref=gl-tw-tw-twitter-ads-rweb'] { display: none !important; }")
            cssRules.append("a[href='https://ads.x.com/?ref=gl-tw-tw-twitter-ads-rweb'] { display: none !important; }")
        }
        
        if s.hideExplore {
            cssRules.append("a[href='/explore'] { display: none !important; }")
        }
        
        if s.hideNotifications {
            cssRules.append("a[href='/notifications'] { display: none !important; }")
        }
        
        if s.hideMessages {
            cssRules.append("a[href='/messages'] { display: none !important; }")
        }
        
        if s.hideCommunities {
            cssRules.append("a[href='/communities'] { display: none !important; }")
        }
        
        if s.hideBookmarks {
            cssRules.append("a[href='/i/bookmarks'] { display: none !important; }")
        }
        
        if s.hideRightColumn {
            cssRules.append(".css-175oi2r.r-yfoy6g.r-18bvks7.r-1867qdf.r-1phboty.r-rs99b7.r-1ifxtd0.r-1udh08x { display: none !important; }")
            cssRules.append(".css-175oi2r.r-18bvks7.r-1867qdf.r-1phboty.r-1ifxtd0.r-1udh08x.r-1niwhzg.r-1yadl64 { display: none !important; }")
            cssRules.append("[data-testid='sidebarColumn'] { display: none !important; }")
        }
        
        if s.hideLeftbar {
            cssRules.append("header[role='banner'] { display: none !important; }")
        }
        
        if s.fillCenter {
            cssRules.append("header[role='banner'] { display: none !important; }")
            cssRules.append("[data-testid='sidebarColumn'] { display: none !important; }")
            cssRules.append("main.css-175oi2r { width: 100% !important; max-width: none !important; margin-left: auto; margin-right: auto; }")
            
            if s.autoResizeWidth {
                cssRules.append("div.r-f8sm7e.r-13qz1uu.r-1ye8kvj { width: var(--dynamic-width, \(s.cssWidth)px) !important; max-width: none !important; margin-left: auto; margin-right: auto; }")
                cssRules.append("div[data-testid='primaryColumn'] { max-width: var(--dynamic-width, \(s.cssWidth)px) !important; }")
            } else {
                cssRules.append("div.r-f8sm7e.r-13qz1uu.r-1ye8kvj { width: \(s.cssWidth)px !important; max-width: none !important; margin-left: auto; margin-right: auto; }")
                cssRules.append("div[data-testid='primaryColumn'] { max-width: \(s.cssWidth)px !important; }")
            }
            
            cssRules.append(".r-113js5t { width: 100% !important; }")
        }
        
        if s.useCustomPadding {
            cssRules.append("div[data-testid='sidebarColumn'] { padding-left: \(s.paddingWidth)px !important; }")
        }
        
        let css = cssRules.joined(separator: "\n")
        
        let observerCode = """
        const settings = {
            hideSelectors: \(s.hideSelectors ? "true" : "false"),
            hideGrok: \(s.hideGrok ? "true" : "false"),
            hideCommunities: \(s.hideCommunities ? "true" : "false"),
            fillCenter: \(s.fillCenter ? "true" : "false"),
            autoResizeWidth: \(s.autoResizeWidth ? "true" : "false"),
            maxWidth: \(s.cssWidth)
        };
        
        if (settings.fillCenter && settings.autoResizeWidth) {
            const updateWidth = () => {
                const windowWidth = window.innerWidth;
                const calculatedWidth = Math.min(windowWidth - 40, settings.maxWidth);
                document.documentElement.style.setProperty('--dynamic-width', calculatedWidth + 'px');
            };
            
            updateWidth();
            let resizeTimer;
            window.addEventListener('resize', () => {
                clearTimeout(resizeTimer);
                resizeTimer = setTimeout(updateWidth, 100);
            });
        };
        
        if (settings.hideSelectors) {
            const observer = new MutationObserver(() => {
                document.querySelectorAll('.css-175oi2r.r-1habvwh.r-eqz5dr.r-uaa2di.r-1mmae3n.r-3pj75a.r-bnwqim').forEach(el => {
                    const parentDiv = el.closest('div');
                    if (parentDiv) parentDiv.remove();
                });
                document.querySelectorAll('div[data-testid="super-upsell-UpsellCardRenderProperties"]').forEach(el => {
                    const parentDiv = el.closest('div.css-175oi2r.r-1ifxtd0');
                    (parentDiv || el).remove();
                });
            });
            observer.observe(document.body, { childList: true, subtree: true });
        }
        
        if (settings.hideGrok) {
            const targetPathD = "M2.205 7.423L11.745 21h4.241L6.446 7.423H2.204zm4.237 7.541L2.2 21h4.243l2.12-3.017-2.121-3.02zM16.957 0L9.624 10.435l2.122 3.02L21.2 0h-4.243zm.767 6.456V21H21.2V1.51l-3.476 4.946z";
            const observer = new MutationObserver(() => {
                document.querySelectorAll('svg[aria-hidden="true"].r-4qtqp9').forEach(svg => {
                    const path = svg.querySelector('path');
                    if (path && path.getAttribute('d') === targetPathD) {
                        const container = svg.closest('a') || svg.closest('button') || svg.closest('div');
                        if (container) container.remove();
                    }
                });
                document.querySelectorAll('button[data-testid="grokImgGen"]').forEach(btn => btn.remove());
            });
            observer.observe(document.body, { childList: true, subtree: true });
        }
        
        if (settings.hideCommunities) {
            const targetPathD = "M7.501 19.917L7.471 21H.472l.029-1.027c.184-6.618 3.736-8.977 7-8.977.963 0 1.95.212 2.87.672-.444.478-.851 1.03-1.212 1.656-.507-.204-1.054-.329-1.658-.329-2.767 0-4.57 2.223-4.938 6.004H7.56c-.023.302-.05.599-.059.917zm15.998.056L23.528 21H9.472l.029-1.027c.184-6.618 3.736-8.977 7-8.977s6.816 2.358 7 8.977zM21.437 19c-.367-3.781-2.17-6.004-4.938-6.004s-4.57 2.223-4.938 6.004h9.875zm-4.938-9c-.799 0-1.527-.279-2.116-.73-.836-.64-1.384-1.638-1.384-2.77 0-1.93 1.567-3.5 3.5-3.5s3.5 1.57 3.5 3.5c0 1.132-.548 2.13-1.384 2.77-.589.451-1.317.73-2.116.73zm-1.5-3.5c0 .827.673 1.5 1.5 1.5s1.5-.673 1.5-1.5-.673-1.5-1.5-1.5-1.5.673-1.5 1.5zM7.5 3C9.433 3 11 4.57 11 6.5S9.433 10 7.5 10 4 8.43 4 6.5 5.567 3 7.5 3zm0 2C6.673 5 6 5.673 6 6.5S6.673 8 7.5 8 9 7.327 9 6.5 8.327 5 7.5 5z";
            const observer = new MutationObserver(() => {
                document.querySelectorAll('svg[aria-hidden="true"].r-4qtqp9').forEach(svg => {
                    const path = svg.querySelector('path');
                    if (path && path.getAttribute('d') === targetPathD) {
                        const container = svg.closest('a') || svg.closest('div');
                        if (container) container.remove();
                    }
                });
            });
            observer.observe(document.body, { childList: true, subtree: true });
        }
        """
        
        return """
        (function() {
            const styleId = 'xmac-clean-ui-style';
            let style = document.getElementById(styleId);
            if (!style) {
                style = document.createElement('style');
                style.id = styleId;
                document.head.appendChild(style);
            }
            style.textContent = `\(css)`;
            
            \(observerCode)
        })();
        """
    }
}

struct CleanUISettings: Codable, Equatable {
    var hideGrok: Bool
    var hidePremiumSignUp: Bool
    var hideSelectors: Bool
    var hideOther: Bool
    var hideExplore: Bool
    var hideNotifications: Bool
    var hideBookmarks: Bool
    var hideMessages: Bool
    var hideCommunities: Bool
    var hideRightColumn: Bool
    var hideLeftbar: Bool
    var fillCenter: Bool
    var autoResizeWidth: Bool
    var cssWidth: Int
    var useCustomPadding: Bool
    var paddingWidth: Int

    static let defaults = CleanUISettings(
        hideGrok: true,
        hidePremiumSignUp: true,
        hideSelectors: true,
        hideOther: true,
        hideExplore: false,
        hideNotifications: false,
        hideBookmarks: false,
        hideMessages: false,
        hideCommunities: false,
        hideRightColumn: false,
        hideLeftbar: false,
        fillCenter: false,
        autoResizeWidth: false,
        cssWidth: 1200,
        useCustomPadding: false,
        paddingWidth: 20
    )
}
