import SwiftUI

@main
struct NewFileMenuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var menuLanguageModel: MenuLanguageModel

    private var menuStrings: AppStrings {
        AppStrings(language: menuLanguageModel.language)
    }

    init() {
        Preferences.ensureDefaults()
        _menuLanguageModel = StateObject(wrappedValue: MenuLanguageModel())
    }

    var body: some Scene {
        MenuBarExtra("NewFileMenu", systemImage: "doc.badge.plus") {
            Button(menuStrings.openSettings) {
                AppWindowController.showSettingsWindow()
            }

            Divider()

            Button(menuStrings.quitApp) {
                NSApp.terminate(nil)
            }
        }
    }
}

@MainActor
private final class MenuLanguageModel: ObservableObject {
    @Published var language: MenuLanguage

    private var observer: NSObjectProtocol?

    init() {
        language = Preferences.load().menuLanguage
        observer = NotificationCenter.default.addObserver(
            forName: Constants.Notifications.preferencesDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.language = Preferences.load().menuLanguage
        }
    }

    deinit {
        if let observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
