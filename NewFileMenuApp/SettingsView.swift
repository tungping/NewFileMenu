import AppKit
import Combine
import SwiftUI

struct SettingsView: View {
    @StateObject private var model = SettingsViewModel()
    @State private var selectedFolderURLs = Set<URL>()

    private var strings: AppStrings {
        AppStrings(language: model.preferences.menuLanguage)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                FolderListView(
                    folders: $model.preferences.monitoredFolderURLs,
                    selection: $selectedFolderURLs,
                    onAdd: model.addFolder,
                    onRemove: { model.removeFolders(selectedFolderURLs) },
                    onRestoreDefaults: {
                        model.restoreDefaultFolders()
                        selectedFolderURLs.removeAll()
                    },
                    strings: strings
                )

                HStack(alignment: .top, spacing: 12) {
                    fileDefaultsSection
                    behaviorSection
                }

                quitSection
            }
            .padding(16)
        }
        .frame(minWidth: 680, minHeight: 340)
    }

    private var fileDefaultsSection: some View {
        GroupBox(strings.fileDefaultsTitle) {
            Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 8) {
                GridRow {
                    Text(strings.menuDisplayTextLabel)
                        .foregroundStyle(.secondary)
                    TextField("", text: $model.preferences.menuDisplayText)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 160)
                }

                GridRow {
                    Text(strings.defaultBaseName)
                        .foregroundStyle(.secondary)
                    TextField("", text: $model.preferences.defaultBaseName)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 160)
                }

                GridRow {
                    Text(strings.defaultExtension)
                        .foregroundStyle(.secondary)
                    TextField("", text: $model.preferences.defaultExtension)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 80)
                }
            }
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }

    private var behaviorSection: some View {
        GroupBox(strings.finderMenuBehaviorTitle) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 24) {
                    Toggle(strings.revealAfterCreate, isOn: $model.preferences.shouldRevealFile)
                    Toggle(strings.preferSubmenu, isOn: $model.preferences.preferSubmenu)
                }

                Picker(strings.menuLanguage, selection: $model.preferences.menuLanguage) {
                    ForEach(MenuLanguage.allCases) { language in
                        Text(language.displayName).tag(language)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 300)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }

    private var quitSection: some View {
        HStack {
            Spacer()
            Button(role: .destructive) {
                model.saveImmediately()
                NSApp.terminate(nil)
            } label: {
                Label(strings.quitApp, systemImage: "power")
            }
        }
    }
}

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var preferences: NewFilePreferences

    private var cancellables = Set<AnyCancellable>()

    init() {
        preferences = Preferences.load()
        observePreferenceChanges()
    }

    func saveImmediately() {
        Preferences.save(preferences)
    }

    func addFolder() {
        let panel = NSOpenPanel()
        panel.title = AppStrings(language: preferences.menuLanguage).folderPanelTitle
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        panel.canCreateDirectories = false

        guard panel.runModal() == .OK else { return }

        let existing = Set(preferences.monitoredFolderURLs.map(\.standardizedFileURL))
        let newFolders = panel.urls
            .map(\.standardizedFileURL)
            .filter { !existing.contains($0) }
        preferences.monitoredFolderURLs.append(contentsOf: newFolders)
    }

    func removeFolders(_ folders: Set<URL>) {
        preferences.monitoredFolderURLs.removeAll { folders.contains($0) }

        if preferences.monitoredFolderURLs.isEmpty {
            restoreDefaultFolders()
        }
    }

    func restoreDefaultFolders() {
        preferences.monitoredFolderURLs = [UserDirectories.homeDirectory]
    }

    private func observePreferenceChanges() {
        $preferences
            .dropFirst()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { preferences in
                Preferences.save(preferences)
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: Constants.Notifications.flushPreferences)
            .sink { [weak self] _ in
                self?.saveImmediately()
            }
            .store(in: &cancellables)
    }
}
