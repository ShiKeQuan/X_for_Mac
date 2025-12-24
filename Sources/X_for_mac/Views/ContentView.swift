import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WebViewModel
    @ObservedObject var preferences: PreferencesStore
    @State private var showingPreferences = false

    var body: some View {
        WebView(viewModel: viewModel)
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button(action: viewModel.goBack) {
                        Image(systemName: "chevron.backward")
                    }
                    .help("Back")
                    .disabled(!viewModel.canGoBack)

                    Button(action: viewModel.goForward) {
                        Image(systemName: "chevron.forward")
                    }
                    .help("Forward")
                    .disabled(!viewModel.canGoForward)

                    Button(action: viewModel.reload) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .help("Reload")

                    Button(action: viewModel.loadHome) {
                        Image(systemName: "house")
                    }
                    .help("Home")

                    Button(action: { showingPreferences = true }) {
                        Image(systemName: "gearshape")
                    }
                    .help("Preferences")
                }
            }
            .sheet(isPresented: $showingPreferences) {
                PreferencesView(preferences: preferences)
            }
            .onAppear {
                viewModel.loadHome()
            }
            .alert("无法在应用内使用 Google 登录", isPresented: Binding(
                get: { viewModel.authWarning != nil },
                set: { isShowing in
                    if !isShowing {
                        viewModel.clearAuthWarning()
                    }
                }
            )) {
                Button("好的", role: .cancel) {
                    viewModel.clearAuthWarning()
                }
            } message: {
                Text(viewModel.authWarning ?? "Google 登录由于拒绝第三方 Cookie，无法支持，请在外部浏览器完成。")
            }
    }
}
