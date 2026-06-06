import SwiftUI

@main
struct NewFileMenuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    private let menuStrings = AppStrings(language: .systemLanguage)

    init() {
        Preferences.ensureDefaults()
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
