import AppKit

struct MenuBuilder {
    let preferences: NewFilePreferences

    func makeMenu(target: AnyObject, action: Selector) -> NSMenu {
        let menu = NSMenu(title: "")
        menu.addItem(actionItem(title: preferences.menuDisplayText, target: target, action: action))
        return menu
    }

    private func actionItem(title: String, target: AnyObject, action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = target
        item.image = NSImage(systemSymbolName: "doc.badge.plus", accessibilityDescription: title)
        return item
    }
}
