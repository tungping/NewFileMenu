import Foundation

public enum FilenameGenerator {
    public static func uniqueFileURL(
        in directoryURL: URL,
        baseName: String,
        fileExtension: String,
        fileManager: FileManager = .default
    ) -> URL {
        let normalizedBaseName = normalizedBaseName(baseName)
        let normalizedExtension = normalizedExtension(fileExtension)

        var suffix = 1
        while suffix <= 9999 {
            let candidateBaseName = suffix == 1
                ? normalizedBaseName
                : "\(normalizedBaseName) \(suffix)"
            let candidateName = fileName(
                baseName: candidateBaseName,
                fileExtension: normalizedExtension
            )
            let candidateURL = directoryURL.appendingPathComponent(candidateName, isDirectory: false)

            if !fileManager.fileExists(atPath: candidateURL.path) {
                return candidateURL
            }

            suffix += 1
        }

        // Fallback: return a UUID-based name if every numbered candidate was taken.
        let fallbackName = fileName(baseName: "\(normalizedBaseName) \(UUID().uuidString)", fileExtension: normalizedExtension)
        return directoryURL.appendingPathComponent(fallbackName, isDirectory: false)
    }

    private static func normalizedBaseName(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let fallback = trimmed.isEmpty ? Constants.defaultBaseName : trimmed
        return fallback.replacingOccurrences(of: "/", with: "-")
    }

    private static func normalizedExtension(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .trimmingCharacters(in: CharacterSet(charactersIn: "."))
            .replacingOccurrences(of: "/", with: "-")
    }

    private static func fileName(baseName: String, fileExtension: String) -> String {
        if fileExtension.isEmpty {
            return baseName
        }

        return "\(baseName).\(fileExtension)"
    }
}
