import Foundation
import Combine

final class PreferencesStore: ObservableObject {
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

    private let defaults: UserDefaults
    private let startPageKey = "startPageURL"
    private let launchOnLoginKey = "launchOnLogin"
    private let defaultStartPage = "https://x.com/home"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.startPageText = defaults.string(forKey: startPageKey) ?? defaultStartPage
        self.launchAtLogin = defaults.object(forKey: launchOnLoginKey) as? Bool ?? false
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
}
