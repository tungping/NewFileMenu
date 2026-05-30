import AppKit

struct MenuBuilder {
    let preferences: NewFilePreferences

    func makeMenu(target: AnyObject, action: Selector) -> NSMenu {
        let labels = MenuLabels(language: preferences.menuLanguage)
        let menu = NSMenu(title: "")

        if preferences.preferSubmenu {
            let parentItem = NSMenuItem(title: labels.parentTitle, action: nil, keyEquivalent: "")
            let submenu = NSMenu(title: labels.parentTitle)
            submenu.addItem(actionItem(title: labels.childTitle, target: target, action: action))
            menu.addItem(parentItem)
            menu.setSubmenu(submenu, for: parentItem)
        } else {
            menu.addItem(actionItem(title: labels.singleItemTitle, target: target, action: action))
        }

        return menu
    }

    private func actionItem(title: String, target: AnyObject, action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = target
        item.image = NSImage(systemSymbolName: "doc.badge.plus", accessibilityDescription: title)
        return item
    }
}

private struct MenuLabels {
    let singleItemTitle: String
    let parentTitle: String
    let childTitle: String

    init(language: MenuLanguage) {
        let strings = AppStrings(language: language)
        singleItemTitle = strings.newTextFile
        parentTitle = strings.newFile
        childTitle = strings.textDocument
    }
}
