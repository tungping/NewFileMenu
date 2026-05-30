import Foundation

public enum FileCreatorError: LocalizedError {
    case targetIsNotDirectory(URL)
    case couldNotCreateFile(URL)

    public var errorDescription: String? {
        switch self {
        case .targetIsNotDirectory(let url):
            return "Target is not a writable directory: \(url.path)"
        case .couldNotCreateFile(let url):
            return "Could not create file: \(url.path)"
        }
    }
}

public enum FileCreator {
    public static func createFile(
        in directoryURL: URL,
        preferences: NewFilePreferences,
        fileManager: FileManager = .default
    ) throws -> URL {
        try createFile(
            in: directoryURL,
            baseName: preferences.defaultBaseName,
            fileExtension: preferences.defaultExtension,
            content: preferences.defaultContent,
            fileManager: fileManager
        )
    }

    public static func createFile(
        in directoryURL: URL,
        baseName: String,
        fileExtension: String,
        content: String,
        fileManager: FileManager = .default
    ) throws -> URL {
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: directoryURL.path, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            throw FileCreatorError.targetIsNotDirectory(directoryURL)
        }

        let targetURL = FilenameGenerator.uniqueFileURL(
            in: directoryURL,
            baseName: baseName,
            fileExtension: fileExtension,
            fileManager: fileManager
        )
        let data = Data(content.utf8)

        guard fileManager.createFile(atPath: targetURL.path, contents: data) else {
            throw FileCreatorError.couldNotCreateFile(targetURL)
        }

        return targetURL
    }
}
