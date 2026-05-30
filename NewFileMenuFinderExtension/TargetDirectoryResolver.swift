import FinderSync
import Foundation
import os

final class TargetDirectoryResolver {
    private let fileManager: FileManager
    private let logger = Logger(subsystem: "com.example.NewFileMenu", category: "TargetDirectoryResolver")

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func resolveTargetDirectory() -> URL? {
        let controller = FIFinderSyncController.default()
        return resolveTargetDirectory(
            selectedItemURLs: controller.selectedItemURLs(),
            targetedURL: controller.targetedURL()
        )
    }

    func resolveTargetDirectory(selectedItemURLs: [URL]?, targetedURL: URL?) -> URL? {
        if let firstSelectedURL = selectedItemURLs?.first {
            return directoryForSelectedItem(firstSelectedURL)
        }

        guard let targetedURL else {
            logger.error("Finder did not provide selectedItemURLs or targetedURL.")
            return nil
        }

        if isDirectory(targetedURL) {
            return targetedURL
        }

        return targetedURL.deletingLastPathComponent()
    }

    private func directoryForSelectedItem(_ url: URL) -> URL {
        if isDirectory(url) {
            return url
        }

        return url.deletingLastPathComponent()
    }

    private func isDirectory(_ url: URL) -> Bool {
        if let values = try? url.resourceValues(forKeys: [.isDirectoryKey]),
           let isDirectory = values.isDirectory {
            return isDirectory
        }

        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        }

        return false
    }
}
