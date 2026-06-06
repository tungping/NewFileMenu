import Foundation

public struct AppStrings {
    public let openSettings: String
    public let quitApp: String
    public let fileDefaultsTitle: String
    public let monitoredFoldersTitle: String
    public let add: String
    public let remove: String
    public let restoreDefaultFolders: String
    public let defaultBaseName: String
    public let defaultExtension: String
    public let menuDisplayTextLabel: String
    public let helpTitle: String
    public let helpEnableExtension: String
    public let helpRestartFinder: String
    public let folderPanelTitle: String

    public init(language: MenuLanguage) {
        switch language {
        case .english:
            openSettings = "Open Settings"
            quitApp = "Quit NewFileMenu"
            fileDefaultsTitle = "Default File"
            monitoredFoldersTitle = "Monitored Folders"
            add = "Add"
            remove = "Remove"
            restoreDefaultFolders = "Restore Defaults"
            defaultBaseName = "Default File Name"
            defaultExtension = "Default Extension"
            menuDisplayTextLabel = "Menu Item Label"
            helpTitle = "Setup"
            helpEnableExtension = "Enable NewFileMenu Finder Extension in System Settings before the Finder context menu appears."
            helpRestartFinder = "If the menu does not refresh, restart Finder or run the main app again, then check the Finder Extension status."
            folderPanelTitle = "Choose Finder Extension monitored folders"
        case .simplifiedChinese:
            openSettings = "打开设置"
            quitApp = "退出 NewFileMenu"
            fileDefaultsTitle = "默认文件"
            monitoredFoldersTitle = "监控目录"
            add = "添加"
            remove = "删除"
            restoreDefaultFolders = "恢复默认目录"
            defaultBaseName = "默认文件名"
            defaultExtension = "默认扩展名"
            menuDisplayTextLabel = "菜单项名称"
            helpTitle = "启用说明"
            helpEnableExtension = "在 System Settings 中启用 NewFileMenu Finder Extension 后，Finder 右键菜单才会出现。"
            helpRestartFinder = "如果菜单没有刷新，可以重启 Finder，或重新运行主 App 后再检查 Finder Extension 状态。"
            folderPanelTitle = "选择 Finder Extension 监控目录"
        case .traditionalChinese:
            openSettings = "開啟設定"
            quitApp = "結束 NewFileMenu"
            fileDefaultsTitle = "預設檔案"
            monitoredFoldersTitle = "監控目錄"
            add = "新增"
            remove = "刪除"
            restoreDefaultFolders = "還原預設目錄"
            defaultBaseName = "預設檔案名稱"
            defaultExtension = "預設副檔名"
            menuDisplayTextLabel = "選單項目名稱"
            helpTitle = "啟用說明"
            helpEnableExtension = "在 System Settings 中啟用 NewFileMenu Finder Extension 後，Finder 右鍵選單才會出現。"
            helpRestartFinder = "如果選單沒有重新整理，可以重啟 Finder，或重新執行主 App 後再檢查 Finder Extension 狀態。"
            folderPanelTitle = "選擇 Finder Extension 監控目錄"
        }
    }
}
