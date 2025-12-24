import Foundation
import WebKit
import AppKit

@MainActor
final class WebViewModel: ObservableObject {
    @Published private(set) var canGoBack = false
    @Published private(set) var canGoForward = false
    @Published private(set) var isLoading = false
    @Published private(set) var currentURL: URL?
    @Published var authWarning: String?
    @Published private(set) var lastBlockedAuthURL: URL?

    private weak var webView: WKWebView?
    private let preferences: PreferencesStore
    private let allowedHosts = [
        "x.com",
        "twitter.com"
    ]

    private let authHosts = [
        "accounts.google.com",
        "accounts.youtube.com",
        "accounts.googleusercontent.com",
        "consent.google.com",
        "oauthaccountmanager.googleapis.com",
        "clients6.google.com",
        "clientchannel.google.com",
        "google.com",
        "www.google.com",
        "gstatic.com",
        "www.gstatic.com"
    ]

    init(preferences: PreferencesStore) {
        self.preferences = preferences
    }

    func attach(webView: WKWebView) {
        self.webView = webView
        loadHome()
    }

    func loadHome() {
        load(url: preferences.startPageURL)
    }

    func load(url: URL) {
        let request = URLRequest(url: url)
        webView?.load(request)
    }

    func reload() {
        if webView?.url == nil {
            loadHome()
            return
        }
        webView?.reload()
    }

    func goBack() {
        webView?.goBack()
    }

    func goForward() {
        webView?.goForward()
    }

    func handleIncoming(_ url: URL) {
        if isAllowed(url: url) {
            load(url: url)
        } else {
            NSWorkspace.shared.open(url)
        }
    }

    func updateNavigationState(from webView: WKWebView) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.canGoBack = webView.canGoBack
            self.canGoForward = webView.canGoForward
            self.isLoading = webView.isLoading
            self.currentURL = webView.url
        }
    }

    func decidePolicy(for url: URL?) -> WKNavigationActionPolicy {
        guard let url else { return .allow }

        if isGoogleAuth(url: url) {
            lastBlockedAuthURL = url
            authWarning = "Google 登录由于拒绝第三方 Cookie，无法在内置窗口完成，请在外部浏览器完成。"
            return .cancel
        }

        guard isAllowed(url: url) else {
            NSWorkspace.shared.open(url)
            return .cancel
        }
        return .allow
    }

    func clearAuthWarning() {
        authWarning = nil
        lastBlockedAuthURL = nil
    }

    private func isAllowed(url: URL) -> Bool {
        if let scheme = url.scheme, scheme == "about" {
            return true
        }

        guard let host = url.host?.lowercased() else { return false }

        if allowedHosts.contains(where: { host.hasSuffix($0) }) {
            return true
        }

        return false
    }

    private func isGoogleAuth(url: URL) -> Bool {
        guard let host = url.host?.lowercased() else { return false }
        return authHosts.contains(where: { host.hasSuffix($0) })
    }
}
