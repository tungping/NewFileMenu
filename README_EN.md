# NewFileMenu

<p align="right">
  <a href="./README.md">简体中文</a>
</p>

NewFileMenu is a self-use-first macOS utility that uses a Finder Sync Extension to add a "New Text File" option to the Finder right-click context menu. The goal is to provide an experience close to Windows' "Right-click > New > Text Document".

## Features

- Finder right-click context menu: `New Text File`
- Optional submenu: `New File > Text Document`
- Right-click blank space in the current folder: Creates a file in the current Finder container directory.
- Right-click a folder: Creates a file inside that folder.
- Right-click a regular file: Creates a file in the parent directory of that file.
- In multi-selection, prioritizes using `selectedItemURLs().first`.
- Default filename: `New Text File.txt`.
- Automatic deduplication: `New Text File 2.txt`, `New Text File 3.txt`, etc.
- By default, reveals and selects the newly created file in Finder.
- The main App does not show a Dock icon and runs constantly in the menu bar. The settings can be opened, or the app can be quit, from the menu bar icon.
- Monitors the user's Home directory by default; additional directories can be added in the settings page.

## Project Positioning

- Swift + SwiftUI
- Finder Sync Extension uses `FinderSync.framework`
- Not targeting the Mac App Store
- Main App's App Sandbox is disabled (Off)
- Finder Sync Extension uses App Sandbox. This is a practical constraint imposed by macOS on loading app extensions. This project uses non-App Store temporary exception entitlements to cover direct file creation under Home and `/Volumes/`.
- Does not use Security-Scoped Bookmarks
- Both the main App and Finder Sync Extension run with current user permissions.
- The file can be created as long as the current user has write permissions for the target directory.

## Directory Structure

```text
NewFileMenu/
├── NewFileMenu.xcodeproj
├── NewFileMenuApp/
│   ├── NewFileMenuApp.swift
│   ├── AppDelegate.swift
│   ├── AppWindowController.swift
│   ├── SettingsView.swift
│   ├── FolderListView.swift
│   ├── ExtensionHelpView.swift
│   ├── Info.plist
│   └── NewFileMenu.entitlements
├── NewFileMenuFinderExtension/
│   ├── FinderSync.swift
│   ├── MenuBuilder.swift
│   ├── TargetDirectoryResolver.swift
│   ├── Info.plist
│   └── NewFileMenuFinderExtension.entitlements
├── Shared/
│   ├── Constants.swift
│   ├── Preferences.swift
│   ├── FileCreator.swift
│   ├── FilenameGenerator.swift
│   ├── AppStrings.swift
│   ├── PreferenceStore.swift
│   └── UserDirectories.swift
├── ConfigExamples/
│   ├── App.entitlements.example
│   ├── FinderExtension.entitlements.example
│   └── FinderExtension.Info.plist.example
├── Tests/
└── Package.swift
```

`Package.swift` is only used for testing the pure logic inside `Shared`. The actual macOS App and Finder Sync Extension use `NewFileMenu.xcodeproj`.

## Xcode Configuration

The project already contains an openable `NewFileMenu.xcodeproj` with two targets:

- `NewFileMenu`
- `NewFileMenuFinderExtension`

Key Configurations:

- Main App's App Sandbox: Off
- Finder Sync Extension's App Sandbox: On
- Finder Sync Extension additionally uses temporary exception entitlements:
  - `com.apple.security.temporary-exception.files.home-relative-path.read-write = /`
  - `com.apple.security.temporary-exception.files.absolute-path.read-write = /Volumes/`
- Main App entitlements: `NewFileMenuApp/NewFileMenu.entitlements`
- Extension entitlements: `NewFileMenuFinderExtension/NewFileMenuFinderExtension.entitlements`
- Extension Info.plist:
  - `NSExtensionPointIdentifier = com.apple.FinderSync`
  - `NSExtensionPrincipalClass = $(PRODUCT_MODULE_NAME).FinderSync`
- The extension is embedded in the main App's `Contents/PlugIns`

Current bundle ID uses placeholder/example values:

- `com.example.NewFileMenu`
- `com.example.NewFileMenu.FinderExtension`

If you want to use it for a long time or share the source code, it is recommended to change these to your own bundle IDs in Xcode.

## Build and Run

1. Open `NewFileMenu.xcodeproj` in Xcode.
2. Select the `NewFileMenu` scheme.
3. If necessary, choose your own Team in the Signing settings or continue using local ad-hoc/temporary signing.
4. Run the main App.
5. Open the main App's settings page and confirm that the monitored directories include your Home directory or the target directory.

The main App runs as a menu bar utility without displaying a Dock icon. Once running, you can open the settings or quit the App from the NewFileMenu icon in the menu bar.

Command-line build check:

```sh
xcodebuild -project NewFileMenu.xcodeproj -scheme NewFileMenu -configuration Debug build CODE_SIGNING_ALLOWED=NO
```

Shared logic tests:

```sh
swift test
```

## Enabling the Finder Extension

After running it for the first time, you need to enable the Finder Extension in System Settings. The entry point varies slightly across different macOS versions; the most reliable way is to search for `Finder Extensions` or `Extensions` in System Settings, locate `NewFileMenu Finder Extension`, and enable it.

If the right-click menu does not appear, you can try running:

```sh
killall Finder
```

Then reopen a Finder window and right-click on the target directory or file.

## Permissions Explanation

The main App does not enable Sandbox, nor does it use Security-Scoped Bookmarks. The Finder Sync Extension must have App Sandbox enabled to be properly registered and loaded by macOS. To satisfy direct file creation in self-use scenarios, the extension uses temporary exception entitlements to cover the user's Home and `/Volumes/`. As long as the current user has write permissions for the target directory, the extension will attempt to create the file directly.

The "Menu Language" in the settings page supports English, Simplified Chinese, and Traditional Chinese. Changing it will simultaneously update the UI of the main App settings page, the menu bar menu, and the Finder right-click menu items.

Unsigned binary distribution may run into Gatekeeper and Finder Extension loading issues. This project is more suitable for sharing in source code form, to be built and run by the users themselves.

## Multi-selection Limitations

Finder Sync has limitations in accurately identifying targets under "multi-selection + right-click". This project handles it according to the following rules:

1. If `selectedItemURLs()` is not empty, use the first URL.
2. If the first URL is a folder, create it inside that folder.
3. If the first URL is a regular file, create it in its parent directory.
4. If `selectedItemURLs()` is empty, use `targetedURL()` as the current Finder container directory.

## Preferences

The main App and Finder Extension share configurations via a local preference file located at:

`~/Library/Application Support/NewFileMenu/Preferences.plist`

Since the Finder Extension is a sandboxed process, the code resolves the actual Home path using the current user's account records to avoid mistakenly setting the default monitored directory to the extension's own sandbox container.

Shared fields include:

- `monitoredFolderURLs`
- `defaultBaseName`
- `defaultExtension`
- `defaultContent`
- `shouldRevealFile`
- `menuLanguage`
- `preferSubmenu`

The default monitored directory is the current user's Home directory, which usually covers Desktop, Documents, Downloads, and most user directories. External drives, iCloud Drive, project directories, etc., can be manually added in the settings page.
