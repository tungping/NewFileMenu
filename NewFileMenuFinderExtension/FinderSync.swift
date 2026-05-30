import AppKit
import FinderSync
import os

final class FinderSync: FIFinderSync {
    private let logger = Logger(subsystem: "com.example.NewFileMenu", category: "FinderSync")
    private let resolver = TargetDirectoryResolver()
    private var cachedMonitoredURLs = Set<URL>()
    private var cachedPreferences: NewFilePreferences?

    override init() {
        super.init()
        Preferences.ensureDefaults()
        refreshMonitoredDirectories(force: true)
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let preferences = Preferences.load()
        cachedPreferences = preferences
        refreshMonitoredDirectories(preferences: preferences)

        return MenuBuilder(preferences: preferences).makeMenu(
            target: self,
            action: #selector(createNewTextFile(_:))
        )
    }

    @objc private func createNewTextFile(_ sender: Any?) {
        let preferences = cachedPreferences ?? Preferences.load()

        guard let targetDirectoryURL = resolver.resolveTargetDirectory() else {
            logger.error("Could not resolve Finder target directory.")
            return
        }

        do {
            let createdFileURL = try FileCreator.createFile(
                in: targetDirectoryURL,
                preferences: preferences
            )

            if preferences.shouldRevealFile {
                NSWorkspace.shared.activateFileViewerSelecting([createdFileURL])
            }

            logger.info("Created file: \(createdFileURL.path, privacy: .public)")
        } catch {
            logger.error("Could not create text file: \(error.localizedDescription, privacy: .public)")
        }
    }

    private func refreshMonitoredDirectories(
        preferences: NewFilePreferences = Preferences.load(),
        force: Bool = false
    ) {
        let folderURLs = Set(preferences.monitoredFolderURLs)

        guard force || folderURLs != cachedMonitoredURLs else { return }

        FIFinderSyncController.default().directoryURLs = folderURLs
        cachedMonitoredURLs = folderURLs
        logger.debug("Monitoring \(folderURLs.count, privacy: .public) Finder folders.")
    }
}
