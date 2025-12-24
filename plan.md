# X for Mac - Plan

## Goal
Create a lightweight macOS desktop wrapper for X (formerly Twitter) that loads the web experience in an isolated window, with basic conveniences (launchable app, minimal menus, notifications optional).

## Approach Options
1) **SwiftUI + WKWebView (recommended)**
   - Native feel, smallest footprint, best macOS integration (notifications, keychain, system menus).
2) **Electron (fallback)**
   - Faster to prototype with web tech; larger app size; more permissions to manage.

## Core Features
- Single-window shell that opens https://x.com and keeps session cookies. **(DONE)**
- Minimal chrome: title bar + toolbar buttons (Back, Forward, Reload, Home). **(DONE)**
- Deep links: handle x.com URLs opened from other apps. **(DONE)**
- Basic preferences:
  - Launch on login (toggle). **(DONE)**
  - Default start page (x.com/home or custom X URL). **(DONE)**
  - Push notifications: deferred.
- Safe external links: non-x.com hosts open in default browser; Google OAuth is blocked in-app with warning. **(DONE)**
- Keyboard shortcuts: Cmd+[ / Cmd+] back/forward, Cmd+R reload, Cmd+Shift+H home. **(DONE)**

## Non-Goals (v1)
- No multi-account switching UI (rely on X web session).
- No offline mode.
- No advanced theming beyond system appearance.

## Architecture (SwiftUI + WKWebView)
- App target: macOS 14+, Swift 5.9+.
- `App` entry: sets up window group and injects `WebViewModel`.
- `WebViewModel`: manages navigation actions, home URL, preference bindings.
- `WebView` wrapper: NSViewRepresentable hosting WKWebView; configures:
  - Custom user agent (optional) to match Safari.
  - Cookie persistence via default `WKWebsiteDataStore`.
  - Navigation delegate to intercept external links and errors.
- `PreferencesView`: toggles for launch on login, start page, notifications.
- `AppMenuCommands`: standard Edit, View, Reload, Back/Forward, Home.
- URL handling: `onOpenURL` to load x.com links.

## Permissions & Security
- Limit navigation to https://x.com and subpaths; open other hosts externally.
- Use WKWebView with `allowsBackForwardNavigationGestures` off (desktop) and no insecure http.
- Do not request microphone/camera unless user triggers X spaces; rely on WKWebView prompts.
- Keep sandboxing on; no file system access needed.

## Notifications Strategy
- Start without push; ship with local notification helper only.
- Optional follow-up: implement Web Push via `WKWebsiteDataStore` and push entitlement; requires user opt-in and app-specific entitlement profile.

## Launch on Login
- Use SMAppService (macOS 13+) to register/unregister login item.
- Store preference in `UserDefaults` and reflect state on startup.

## Build & Packaging
- Tooling: Xcode project.
- Targets: main app only (no helper unless login item uses helper target).
- Signing: Developer ID or Personal Team for local use; enable hardened runtime.
- Distribution: .app in /Applications; optional .dmg via create-dmg.

## Milestones
1) Skeleton app: SwiftUI window, WKWebView loads https://x.com, toolbar buttons wired.
2) Navigation guard: external links open in default browser; deep link handling.
3) Preferences: home URL, launch on login toggle; persist in UserDefaults.
4) Polish: icons, menu commands, keyboard shortcuts, basic error page.
5) Block Google SSO inside app; show warning; disable Google button UI injection. **(DONE)**
6) Optional: notification opt-in flow; push entitlement experiment.

## Upcoming Feature: Clean UI (multi-language)
- Hide UI elements (Grok, Premium/Verified Orgs, other promo modules, Explore/Notifications/Messages/Communities/Bookmarks), right sidebar, muted notices.
- Customizable post-area width and padding; apply user-selected layout prefs.
- In-app settings sheet to toggle each hide option; persist to UserDefaults.
- Language pack based on browser locale (en/zh-CN/zh-TW/ja) with strings adapted from function.js user script.
- Implementation sketch:
  - Inject WKUserScript at document start to strip targeted selectors and add optional banner.
  - Settings model mirroring function.js defaults; bind to UI sheet; on save, reload WKWebView.
  - Selector map and text-match strategy derived from /Users/kequan/Desktop/Test/X_for_mac/function.js.
  - Allow reset to defaults.

## Status
- App runs as .app bundle (manual pack + codesign), Google SSO blocked with warning, toolbar/navigation working.
- Next: add clean-UI controls + localization and wire to injected script.

## Assets
- App icon: create simple monochrome "X" vector, export ICNS via Asset Catalog.

## Testing
- Smoke: sign in/out, navigate timeline, compose post, media playback, Spaces join prompt.
- System integration: open x.com link from Safari -> app; check back/forward shortcuts; login item toggle works.
- Regression: external link handling, start page preference honored.
