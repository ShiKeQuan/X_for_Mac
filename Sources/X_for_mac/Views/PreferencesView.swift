import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences: PreferencesStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Form {
                Section(header: Text("Start Page")) {
                    TextField("https://x.com/home", text: $preferences.startPageText)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit { dismiss() }
                    Text("Only x.com or twitter.com links are allowed; others open in the browser.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section(header: Text("Launch")) {
                    Toggle("Launch on login", isOn: $preferences.launchAtLogin)
                        .toggleStyle(.switch)
                    Text("Requires the app to be in Applications and may need a relaunch to take effect.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            HStack {
                Spacer()
                Button("Close") { dismiss() }
                    .keyboardShortcut(.escape, modifiers: [])
            }
        }
        .padding()
        .frame(width: 380)
    }
}
