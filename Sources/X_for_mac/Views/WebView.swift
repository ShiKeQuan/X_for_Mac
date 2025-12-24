import SwiftUI
import WebKit
import AppKit

struct WebView: NSViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    @ObservedObject var preferences: PreferencesStore

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel, preferences: preferences)
    }

    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsAirPlayForMediaPlayback = true
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.websiteDataStore = .default()

        let controller = configuration.userContentController
        controller.removeAllUserScripts()
        controller.addUserScript(Self.makeGoogleBlockScript())
        controller.addUserScript(Self.makeCleanUIScript(preferences: preferences))

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.setValue(false, forKey: "drawsBackground")
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15"
        webView.allowsMagnification = true
        webView.magnification = 1.0

        viewModel.attach(webView: webView)
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        context.coordinator.ensureScripts(in: nsView)
    }

    @MainActor
    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        private let viewModel: WebViewModel
        private let preferences: PreferencesStore
        private var lastRevision: Int = -1

        init(viewModel: WebViewModel, preferences: PreferencesStore) {
            self.viewModel = viewModel
            self.preferences = preferences
        }

        func ensureScripts(in webView: WKWebView) {
            guard lastRevision != preferences.cleanUIRevision else { return }
            let controller = webView.configuration.userContentController
            controller.removeAllUserScripts()
            controller.addUserScript(WebView.makeGoogleBlockScript())
            controller.addUserScript(WebView.makeCleanUIScript(preferences: preferences))
            lastRevision = preferences.cleanUIRevision
            webView.reload()
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping @MainActor @Sendable (WKNavigationActionPolicy) -> Void
        ) {
            let policy = viewModel.decidePolicy(for: navigationAction.request.url)
            decisionHandler(policy)
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            ensureScripts(in: webView)
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            viewModel.updateNavigationState(from: webView)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            viewModel.updateNavigationState(from: webView)
        }

        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            webView.reload()
        }

        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            guard navigationAction.targetFrame == nil, let url = navigationAction.request.url else {
                return nil
            }

            let policy = viewModel.decidePolicy(for: url)
            if policy == .allow {
                webView.load(URLRequest(url: url))
            }
            return nil
        }
    }
}

private extension WebView {
    static func makeGoogleBlockScript() -> WKUserScript {
        let script = """
        (function() {
            const selectors = [
                '[data-testid="google_signin_button"]',
                'a[href*="google.com"]',
                'button[data-testid="google_sso_button"]',
                'button:has(img[src*="google"])',
                'div:has([src*="google"]) button',
                'div:has(img[src*="google"])'
            ];

            const removeByText = () => {
                const nodes = document.querySelectorAll('button, a, div, span');
                nodes.forEach(el => {
                    const text = (el.innerText || el.textContent || '').toLowerCase();
                    const aria = (el.getAttribute('aria-label') || '').toLowerCase();
                    const href = (el.getAttribute('href') || '').toLowerCase();
                    if (text.includes('google') || aria.includes('google') || href.includes('google.com')) {
                        el.remove();
                    }
                });
            };

            const removeGoogle = () => {
                selectors.forEach(sel => {
                    document.querySelectorAll(sel).forEach(el => {
                        el.remove();
                    });
                });
                removeByText();
            };

            const insertBanner = () => {
                if (document.getElementById('xmac-google-banner')) return;
                const banner = document.createElement('div');
                banner.id = 'xmac-google-banner';
                const messages = {
                    'en': 'Google login is disabled in this app. Please use email/password or complete login in your browser.',
                    'zh-CN': 'Google 登录已在此应用禁用，请使用邮箱/密码或在浏览器完成。'
                };
                const lang = navigator.language || 'zh-CN';
                banner.textContent = messages[lang] || messages['zh-CN'];
                banner.style.cssText = 'background:#2d2d2d;color:#ffd166;padding:10px 12px;font-size:12px;border-radius:8px;margin:8px 0;text-align:center;';
                const parent = document.querySelector('[data-testid="LoginForm_UserInput"]')?.parentElement || document.body;
                parent.insertBefore(banner, parent.firstChild);
            };

            const observer = new MutationObserver(() => {
                removeGoogle();
                insertBanner();
            });

            removeGoogle();
            insertBanner();
            observer.observe(document.documentElement || document.body, { childList: true, subtree: true });
        })();
        """
        return WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: true)
    }

    static func makeCleanUIScript(preferences: PreferencesStore) -> WKUserScript {
        let source = preferences.makeCleanUIScript()
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
    }
}
