import Foundation

public enum MenuLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"

    @available(*, deprecated, renamed: "simplifiedChinese")
    public static var chinese: MenuLanguage { .simplifiedChinese }

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .english:
            return "English"
        case .simplifiedChinese:
            return "简体中文"
        case .traditionalChinese:
            return "繁體中文"
        }
    }
}

public struct NewFilePreferences: Equatable {
    public var monitoredFolderURLs: [URL]
    public var defaultBaseName: String
    public var defaultExtension: String
    public var defaultContent: String
    public var menuDisplayText: String
    public var shouldRevealFile: Bool
    public var menuLanguage: MenuLanguage
    public var preferSubmenu: Bool

    public init(
        monitoredFolderURLs: [URL] = [FileManager.default.homeDirectoryForCurrentUser],
        defaultBaseName: String = Constants.defaultBaseName,
        defaultExtension: String = Constants.defaultFileExtension,
        defaultContent: String = "",
        menuDisplayText: String = Constants.defaultMenuDisplayText,
        shouldRevealFile: Bool = true,
        menuLanguage: MenuLanguage = .simplifiedChinese,
        preferSubmenu: Bool = false
    ) {
        self.monitoredFolderURLs = monitoredFolderURLs
        self.defaultBaseName = defaultBaseName
        self.defaultExtension = defaultExtension
        self.defaultContent = defaultContent
        self.menuDisplayText = menuDisplayText
        self.shouldRevealFile = shouldRevealFile
        self.menuLanguage = menuLanguage
        self.preferSubmenu = preferSubmenu
    }
}

public enum Preferences {
    private static var defaultValues: [String: Any] {
        [
            Constants.PreferenceKeys.monitoredFolderURLs: [UserDirectories.homeDirectory.path],
            Constants.PreferenceKeys.defaultBaseName: Constants.defaultBaseName,
            Constants.PreferenceKeys.defaultExtension: Constants.defaultFileExtension,
            Constants.PreferenceKeys.defaultContent: "",
            Constants.PreferenceKeys.menuDisplayText: Constants.defaultMenuDisplayText,
            Constants.PreferenceKeys.shouldRevealFile: true,
            Constants.PreferenceKeys.menuLanguage: MenuLanguage.simplifiedChinese.rawValue,
            Constants.PreferenceKeys.preferSubmenu: false
        ]
    }

    public static func ensureDefaults() {
        let persisted = PreferenceStore.loadDictionary()
        var merged = persisted
        var didChange = persisted.isEmpty

        for (key, value) in defaultValues where merged[key] == nil {
            merged[key] = value
            didChange = true
        }

        if didChange {
            PreferenceStore.saveDictionary(merged)
        }
    }

    public static func load() -> NewFilePreferences {
        let persisted = PreferenceStore.loadDictionary()
        let values = defaultValues.merging(persisted) { _, persisted in persisted }

        let folderPaths = values[Constants.PreferenceKeys.monitoredFolderURLs] as? [String]
        let folders = (folderPaths ?? [UserDirectories.homeDirectory.path])
            .map { URL(fileURLWithPath: $0) }

        let languageValue = values[Constants.PreferenceKeys.menuLanguage] as? String
        let language = languageValue.flatMap(MenuLanguage.init(rawValue:)) ?? .simplifiedChinese

        return NewFilePreferences(
            monitoredFolderURLs: folders.isEmpty ? [UserDirectories.homeDirectory] : folders,
            defaultBaseName: values[Constants.PreferenceKeys.defaultBaseName] as? String ?? Constants.defaultBaseName,
            defaultExtension: values[Constants.PreferenceKeys.defaultExtension] as? String ?? Constants.defaultFileExtension,
            defaultContent: values[Constants.PreferenceKeys.defaultContent] as? String ?? "",
            menuDisplayText: values[Constants.PreferenceKeys.menuDisplayText] as? String ?? Constants.defaultMenuDisplayText,
            shouldRevealFile: values[Constants.PreferenceKeys.shouldRevealFile] as? Bool ?? true,
            menuLanguage: language,
            preferSubmenu: values[Constants.PreferenceKeys.preferSubmenu] as? Bool ?? false
        )
    }

    public static func save(_ preferences: NewFilePreferences) {
        PreferenceStore.saveDictionary([
            Constants.PreferenceKeys.monitoredFolderURLs: preferences.monitoredFolderURLs.map { $0.standardizedFileURL.path },
            Constants.PreferenceKeys.defaultBaseName: preferences.defaultBaseName,
            Constants.PreferenceKeys.defaultExtension: preferences.defaultExtension,
            Constants.PreferenceKeys.defaultContent: preferences.defaultContent,
            Constants.PreferenceKeys.menuDisplayText: preferences.menuDisplayText,
            Constants.PreferenceKeys.shouldRevealFile: preferences.shouldRevealFile,
            Constants.PreferenceKeys.menuLanguage: preferences.menuLanguage.rawValue,
            Constants.PreferenceKeys.preferSubmenu: preferences.preferSubmenu
        ])
        NotificationCenter.default.post(name: Constants.Notifications.preferencesDidChange, object: nil)
    }
}
