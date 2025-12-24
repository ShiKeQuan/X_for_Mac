import SwiftUI

@main
struct XForMacApp: App {
    @StateObject private var preferences: PreferencesStore
    @StateObject private var viewModel: WebViewModel

    init() {
        let prefs = PreferencesStore()
        _preferences = StateObject(wrappedValue: prefs)
        _viewModel = StateObject(wrappedValue: WebViewModel(preferences: prefs))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel, preferences: preferences)
                .onOpenURL { url in
                    viewModel.handleIncoming(url)
                }
        }
        .commands {
            AppMenuCommands(viewModel: viewModel, preferences: preferences)
        }

        Settings {
            PreferencesView(preferences: preferences)
        }
    }
}
