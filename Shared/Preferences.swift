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

    public static var systemLanguage: MenuLanguage {
        guard let preferredLanguage = Locale.preferredLanguages.first?.lowercased() else {
            return .english
        }
        
        if preferredLanguage.contains("zh-hans") {
            return .simplifiedChinese
        } else if preferredLanguage.contains("zh-hant") || preferredLanguage.contains("zh-hk") || preferredLanguage.contains("zh-tw") {
            return .traditionalChinese
        } else {
            return .english
        }
    }
}

public struct NewFilePreferences: Equatable {
    public var monitoredFolderURLs: [URL]
    public var defaultBaseName: String
    public var defaultExtension: String
    public var defaultContent: String
    public var menuDisplayText: String

    public init(
        monitoredFolderURLs: [URL] = [FileManager.default.homeDirectoryForCurrentUser],
        defaultBaseName: String = Constants.defaultBaseName,
        defaultExtension: String = Constants.defaultFileExtension,
        defaultContent: String = "",
        menuDisplayText: String = Constants.defaultMenuDisplayText
    ) {
        self.monitoredFolderURLs = monitoredFolderURLs
        self.defaultBaseName = defaultBaseName
        self.defaultExtension = defaultExtension
        self.defaultContent = defaultContent
        self.menuDisplayText = menuDisplayText
    }
}

public enum Preferences {
    private static var defaultValues: [String: Any] {
        [
            Constants.PreferenceKeys.monitoredFolderURLs: [UserDirectories.homeDirectory.path],
            Constants.PreferenceKeys.defaultBaseName: Constants.defaultBaseName,
            Constants.PreferenceKeys.defaultExtension: Constants.defaultFileExtension,
            Constants.PreferenceKeys.defaultContent: "",
            Constants.PreferenceKeys.menuDisplayText: Constants.defaultMenuDisplayText
        ]
    }

    public static func ensureDefaults() {
        let persisted = PreferenceStore.loadDictionary()
        ensureDefaults(merging: persisted)
    }

    /// Accepts a pre-loaded preferences snapshot to avoid a redundant plist read.
    public static func ensureDefaults(from loaded: NewFilePreferences) {
        // Re-encode the loaded preferences into the same dictionary shape so we can
        // check for missing keys without a second plist read.
        let persisted: [String: Any] = [
            Constants.PreferenceKeys.monitoredFolderURLs: loaded.monitoredFolderURLs.map { $0.standardizedFileURL.path },
            Constants.PreferenceKeys.defaultBaseName: loaded.defaultBaseName,
            Constants.PreferenceKeys.defaultExtension: loaded.defaultExtension,
            Constants.PreferenceKeys.defaultContent: loaded.defaultContent,
            Constants.PreferenceKeys.menuDisplayText: loaded.menuDisplayText
        ]
        ensureDefaults(merging: persisted)
    }

    private static func ensureDefaults(merging persisted: [String: Any]) {
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

        return NewFilePreferences(
            monitoredFolderURLs: folders.isEmpty ? [UserDirectories.homeDirectory] : folders,
            defaultBaseName: values[Constants.PreferenceKeys.defaultBaseName] as? String ?? Constants.defaultBaseName,
            defaultExtension: values[Constants.PreferenceKeys.defaultExtension] as? String ?? Constants.defaultFileExtension,
            defaultContent: values[Constants.PreferenceKeys.defaultContent] as? String ?? "",
            menuDisplayText: values[Constants.PreferenceKeys.menuDisplayText] as? String ?? Constants.defaultMenuDisplayText
        )
    }

    public static func save(_ preferences: NewFilePreferences) {
        PreferenceStore.saveDictionary([
            Constants.PreferenceKeys.monitoredFolderURLs: preferences.monitoredFolderURLs.map { $0.standardizedFileURL.path },
            Constants.PreferenceKeys.defaultBaseName: preferences.defaultBaseName,
            Constants.PreferenceKeys.defaultExtension: preferences.defaultExtension,
            Constants.PreferenceKeys.defaultContent: preferences.defaultContent,
            Constants.PreferenceKeys.menuDisplayText: preferences.menuDisplayText
        ])
        NotificationCenter.default.post(name: Constants.Notifications.preferencesDidChange, object: nil)
    }
}
