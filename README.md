# NewFileMenu

<p align="right">
  <a href="./README_EN.md">English</a>
</p>

NewFileMenu 是一个自用优先的 macOS 工具，用 Finder Sync Extension 在 Finder 右键菜单里添加“新建文本文件”。目标体验接近 Windows 的“右键 > 新建 > 文本文档”。

## 功能

- Finder 右键菜单：`新建文本文件`
- 可选子菜单：`新建文件 > 文本文档`
- 右键当前文件夹空白处：在当前 Finder 容器目录创建文件
- 右键文件夹：在该文件夹内部创建文件
- 右键普通文件：在该文件所在父目录创建文件
- 多选时优先使用 `selectedItemURLs().first`
- 默认文件名：`New Text File.txt`
- 自动去重：`New Text File 2.txt`、`New Text File 3.txt`
- 创建成功后默认让 Finder 显示并选中新文件
- 主 App 不显示 Dock 图标，常驻菜单栏，可从菜单栏图标打开设置或退出
- 默认监控用户 Home 目录，可在设置页添加额外目录

## 项目定位

- Swift + SwiftUI
- Finder Sync Extension 使用 `FinderSync.framework`
- 不面向 Mac App Store
- 主 App 的 App Sandbox 关闭
- Finder Sync Extension 使用 App Sandbox。macOS 对 app extension 加载有这个现实约束；本项目通过非 App Store 的 temporary exception entitlements 覆盖 Home 和 `/Volumes` 下的直接文件创建。
- 不使用 Security-Scoped Bookmarks
- 主 App 和 Finder Sync Extension 以当前用户权限运行
- 当前用户对目标目录有写权限即可创建文件

## 目录结构

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

`Package.swift` 只用于测试 `Shared` 里的纯逻辑。真正的 macOS App 和 Finder Sync Extension 使用 `NewFileMenu.xcodeproj`。

## Xcode 配置

项目已经包含一个可打开的 `NewFileMenu.xcodeproj`，包含两个 targets：

- `NewFileMenu`
- `NewFileMenuFinderExtension`

关键配置：

- 主 App 的 App Sandbox：Off
- Finder Sync Extension 的 App Sandbox：On
- Finder Sync Extension 额外使用 temporary exception entitlements：
  - `com.apple.security.temporary-exception.files.home-relative-path.read-write = /`
  - `com.apple.security.temporary-exception.files.absolute-path.read-write = /Volumes/`
- 主 App entitlements：`NewFileMenuApp/NewFileMenu.entitlements`
- Extension entitlements：`NewFileMenuFinderExtension/NewFileMenuFinderExtension.entitlements`
- Extension Info.plist：
  - `NSExtensionPointIdentifier = com.apple.FinderSync`
  - `NSExtensionPrincipalClass = $(PRODUCT_MODULE_NAME).FinderSync`
- Extension 会嵌入到主 App 的 `Contents/PlugIns`

当前 bundle id 使用示例值：

- `com.example.NewFileMenu`
- `com.example.NewFileMenu.FinderExtension`

如果你要长期自用或分享源码，建议在 Xcode 中换成自己的 bundle id。

## 编译运行

1. 用 Xcode 打开 `NewFileMenu.xcodeproj`。
2. 选择 `NewFileMenu` scheme。
3. 如有需要，在 Signing 设置中选择自己的 Team 或继续使用本地临时签名。
4. Run 主 App。
5. 打开主 App 设置页，确认监控目录包含你的 Home 目录或目标目录。

主 App 作为菜单栏工具运行，不显示 Dock 图标。运行后可以从菜单栏的 NewFileMenu 图标打开设置，也可以从同一个菜单退出 App。

命令行编译检查：

```sh
xcodebuild -project NewFileMenu.xcodeproj -scheme NewFileMenu -configuration Debug build CODE_SIGNING_ALLOWED=NO
```

共享逻辑测试：

```sh
swift test
```

## 启用 Finder Extension

第一次运行后，需要在 System Settings 中启用 Finder Extension。不同 macOS 版本入口略有差异，最稳妥的方法是在 System Settings 搜索 `Finder Extensions` 或 `Extensions`，找到 `NewFileMenu Finder Extension` 并启用。

如果右键菜单没有出现，可以尝试：

```sh
killall Finder
```

然后重新打开 Finder 窗口再右键目标目录或文件。

## 权限说明

主 App 不启用 Sandbox，也不使用 Security-Scoped Bookmarks。Finder Sync Extension 需要启用 App Sandbox 才能被 macOS 正常注册和启用；为满足自用场景下的直接文件创建，扩展使用 temporary exception entitlements 覆盖用户 Home 和 `/Volumes`。只要当前用户对目标目录有写权限，扩展会尝试直接创建文件。

设置页中的“菜单语言”支持 English、简体中文、繁體中文，并会同步影响主 App 设置页、菜单栏菜单和 Finder 右键菜单文字。

未签名二进制分发可能遇到 Gatekeeper 和 Finder Extension 加载问题。这个项目更适合以源码形式分享，由使用者自行编译运行。

## 多选限制

Finder Sync 对“多选 + 右键”的精确目标识别有限制。本项目按以下规则处理：

1. 如果 `selectedItemURLs()` 非空，使用第一个 URL。
2. 如果第一个 URL 是文件夹，在该文件夹内部创建。
3. 如果第一个 URL 是普通文件，在其父目录创建。
4. 如果 `selectedItemURLs()` 为空，使用 `targetedURL()` 作为当前 Finder 容器目录。

## 偏好设置

主 App 和 Finder Extension 通过本机偏好设置文件共享，路径为：

`~/Library/Application Support/NewFileMenu/Preferences.plist`

Finder Extension 是沙盒进程，代码会通过当前用户账号记录解析真实 Home 路径，避免把默认监控目录误设成扩展自己的 sandbox container。

共享字段包括：

- `monitoredFolderURLs`
- `defaultBaseName`
- `defaultExtension`
- `defaultContent`
- `shouldRevealFile`
- `menuLanguage`
- `preferSubmenu`

默认监控目录是当前用户 Home 目录，通常覆盖 Desktop、Documents、Downloads 和大部分用户目录。外置硬盘、iCloud Drive、项目目录等可以在设置页手动添加。
