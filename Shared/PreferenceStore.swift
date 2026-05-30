import Foundation

enum PreferenceStore {
    private static let fileURL: URL = UserDirectories.applicationSupportDirectory
        .appendingPathComponent(Constants.appName, isDirectory: true)
        .appendingPathComponent("Preferences.plist", isDirectory: false)

    private static let parentDirectoryState = ParentDirectoryState()

    static func loadDictionary() -> [String: Any] {
        guard let dictionary = NSDictionary(contentsOf: fileURL) as? [String: Any] else {
            return [:]
        }

        return dictionary
    }

    static func saveDictionary(_ dictionary: [String: Any]) {
        ensureParentDirectoryExists()
        (dictionary as NSDictionary).write(to: fileURL, atomically: true)
    }

    private static func ensureParentDirectoryExists() {
        let fileManager = FileManager.default
        let parentDirectory = fileURL.deletingLastPathComponent()
        var isDirectory: ObjCBool = false

        parentDirectoryState.lock.lock()
        defer { parentDirectoryState.lock.unlock() }

        guard !parentDirectoryState.verified else { return }

        if fileManager.fileExists(atPath: parentDirectory.path, isDirectory: &isDirectory),
           isDirectory.boolValue {
            parentDirectoryState.verified = true
            return
        }

        do {
            try fileManager.createDirectory(at: parentDirectory, withIntermediateDirectories: true)
            parentDirectoryState.verified = true
        } catch {
            parentDirectoryState.verified = false
        }
    }
}

private final class ParentDirectoryState: @unchecked Sendable {
    let lock = NSLock()
    var verified = false
}
