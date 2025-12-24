import SwiftUI

struct AppMenuCommands: Commands {
    @ObservedObject var viewModel: WebViewModel
    @ObservedObject var preferences: PreferencesStore

    var body: some Commands {
        CommandMenu("Navigation") {
            Button("Back") { viewModel.goBack() }
                .keyboardShortcut("[", modifiers: .command)
                .disabled(!viewModel.canGoBack)
            Button("Forward") { viewModel.goForward() }
                .keyboardShortcut("]", modifiers: .command)
                .disabled(!viewModel.canGoForward)
            Button("Reload") { viewModel.reload() }
                .keyboardShortcut("r", modifiers: .command)
            Button("Home") { viewModel.loadHome() }
                .keyboardShortcut("h", modifiers: [.command, .shift])
        }
    }
}
