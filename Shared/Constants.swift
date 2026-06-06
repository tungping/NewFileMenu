import Foundation

public enum Constants {
    public static let appName = "NewFileMenu"
    public static let defaultBaseName = "untitled"
    public static let defaultMenuDisplayText = "New Text File"
    public static let defaultFileExtension = "txt"
    public static let finderBundleIdentifier = "com.apple.finder"

    public enum PreferenceKeys {
        public static let monitoredFolderURLs = "monitoredFolderURLs"
        public static let defaultBaseName = "defaultBaseName"
        public static let defaultExtension = "defaultExtension"
        public static let defaultContent = "defaultContent"
        public static let menuDisplayText = "menuDisplayText"
        public static let menuLanguage = "menuLanguage"
    }

    public enum Notifications {
        public static let preferencesDidChange = Notification.Name("NewFileMenu.preferencesDidChange")
        public static let flushPreferences = Notification.Name("NewFileMenu.flushPreferences")
    }
}
