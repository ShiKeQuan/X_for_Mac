import SwiftUI

struct PreferencesView: View {
    @ObservedObject var preferences: PreferencesStore
    @Environment(\.dismiss) private var dismiss

    private var loc: LocalizedStrings {
        preferences.localizedStrings
    }
    
    private let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(loc.preferences)
                .font(.title2)
                .bold()
                .padding(.bottom, 8)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(loc.general).font(.headline)
                        
                        HStack {
                            Text(loc.languageLabel + ":")
                                .frame(width: 100, alignment: .leading)
                            Picker("", selection: $preferences.language) {
                                ForEach(Language.allCases) { lang in
                                    Text(lang.displayName).tag(lang.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(loc.startPage).font(.headline)
                        TextField("https://x.com/home", text: $preferences.startPageText)
                            .textFieldStyle(.roundedBorder)
                        Text("Only x.com or twitter.com allowed")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text(loc.launchOnLogin).font(.headline)
                        Toggle(loc.launchOnLogin, isOn: $preferences.launchAtLogin)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text(loc.cleanUI).font(.headline)
                        Toggle(loc.hideGrok, isOn: $preferences.cleanUISettings.hideGrok)
                        Toggle(loc.hidePremium, isOn: $preferences.cleanUISettings.hidePremiumSignUp)
                        Toggle(loc.hideSelectors, isOn: $preferences.cleanUISettings.hideSelectors)
                        Toggle(loc.hideExplore, isOn: $preferences.cleanUISettings.hideExplore)
                        Toggle(loc.hideNotifications, isOn: $preferences.cleanUISettings.hideNotifications)
                        Toggle(loc.hideMessages, isOn: $preferences.cleanUISettings.hideMessages)
                        Toggle(loc.hideCommunities, isOn: $preferences.cleanUISettings.hideCommunities)
                        Toggle(loc.hideBookmarks, isOn: $preferences.cleanUISettings.hideBookmarks)
                        Toggle(loc.hideRightColumn, isOn: $preferences.cleanUISettings.hideRightColumn)
                        Toggle(loc.hideLeftbar, isOn: $preferences.cleanUISettings.hideLeftbar)
                        
                        Divider().padding(.vertical, 4)
                        
                        Toggle(loc.fillCenter, isOn: $preferences.cleanUISettings.fillCenter)
                        if preferences.cleanUISettings.fillCenter {
                            VStack(alignment: .leading, spacing: 8) {
                                Toggle(loc.autoResize, isOn: $preferences.cleanUISettings.autoResizeWidth)
                                    .padding(.leading, 20)
                                
                                HStack {
                                    Text(loc.centerWidth + ":")
                                        .frame(width: 80, alignment: .leading)
                                    TextField("1200", value: $preferences.cleanUISettings.cssWidth, formatter: numberFormatter)
                                        .frame(width: 80)
                                        .textFieldStyle(.roundedBorder)
                                        .disabled(preferences.cleanUISettings.autoResizeWidth)
                                    Text(loc.px)
                                    if preferences.cleanUISettings.autoResizeWidth {
                                        Text("(\(loc.centerWidth.lowercased()))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    } else {
                                        Text("(600-3000)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.leading, 20)
                            }
                        }
                        
                        Divider().padding(.vertical, 4)
                        
                        Toggle(loc.customPadding, isOn: $preferences.cleanUISettings.useCustomPadding)
                        if preferences.cleanUISettings.useCustomPadding {
                            HStack {
                                Text(loc.padding + ":")
                                    .frame(width: 80, alignment: .leading)
                                TextField("20", value: $preferences.cleanUISettings.paddingWidth, formatter: numberFormatter)
                                    .frame(width: 80)
                                    .textFieldStyle(.roundedBorder)
                                Text(loc.px)
                            }
                            .padding(.leading, 20)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
            
            Divider()
            
            HStack {
                Spacer()
                Button("Close") { dismiss() }
                    .keyboardShortcut(.escape, modifiers: [])
            }
        }
        .padding(20)
        .frame(width: 450, height: 600)
    }
}
