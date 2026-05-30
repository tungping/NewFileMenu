import Foundation

#if os(macOS)
import Darwin
#endif

public enum UserDirectories {
    public static let homeDirectory: URL = {
        #if os(macOS)
        if let passwordRecord = getpwuid(getuid()),
           let homePath = passwordRecord.pointee.pw_dir {
            return URL(fileURLWithPath: String(cString: homePath), isDirectory: true)
        }
        #endif

        return FileManager.default.homeDirectoryForCurrentUser
    }()

    public static var applicationSupportDirectory: URL {
        homeDirectory
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Application Support", isDirectory: true)
    }
}
