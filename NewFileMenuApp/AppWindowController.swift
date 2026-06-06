import AppKit
import SwiftUI

final class AppWindowController: NSObject, NSWindowDelegate {
    static let shared = AppWindowController()

    private var settingsWindow: NSWindow?

    private override init() {}

    static func showSettingsWindow() {
        shared.showSettingsWindow()
    }

    private func showSettingsWindow() {
        NSApp.activate(ignoringOtherApps: true)

        if let window = settingsWindow {
            if window.isMiniaturized {
                window.deminiaturize(nil)
            }
            window.makeKeyAndOrderFront(nil)
            return
        }

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 680, height: 340),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "NewFileMenu"
        window.center()
        window.contentView = NSHostingView(rootView: SettingsView())
        window.isReleasedWhenClosed = false
        window.delegate = self
        settingsWindow = window
        window.makeKeyAndOrderFront(nil)
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NotificationCenter.default.post(name: Constants.Notifications.flushPreferences, object: nil)
        sender.orderOut(nil)
        return false
    }
}
