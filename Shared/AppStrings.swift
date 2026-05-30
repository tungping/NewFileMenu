import Foundation

public struct AppStrings {
    public let openSettings: String
    public let quitApp: String
    public let statusTitle: String
    public let fileDefaultsTitle: String
    public let monitoredFoldersTitle: String
    public let add: String
    public let remove: String
    public let restoreDefaultFolders: String
    public let defaultBaseName: String
    public let defaultExtension: String
    public let defaultContent: String
    public let finderMenuBehaviorTitle: String
    public let revealAfterCreate: String
    public let preferSubmenu: String
    public let menuLanguage: String
    public let helpTitle: String
    public let helpEnableExtension: String
    public let helpRestartFinder: String
    public let folderPanelTitle: String
    public let newTextFile: String
    public let newFile: String
    public let textDocument: String

    public init(language: MenuLanguage) {
        switch language {
        case .english:
            openSettings = "Open Settings"
            quitApp = "Quit NewFileMenu"
            statusTitle = "Status"
            fileDefaultsTitle = "Default File"
            monitoredFoldersTitle = "Monitored Folders"
            add = "Add"
            remove = "Remove"
            restoreDefaultFolders = "Restore Defaults"
            defaultBaseName = "Default File Name"
            defaultExtension = "Default Extension"
            defaultContent = "Default File Content"
            finderMenuBehaviorTitle = "Finder Menu Behavior"
            revealAfterCreate = "Reveal file after creating"
            preferSubmenu = "Prefer submenu"
            menuLanguage = "Menu Language"
            helpTitle = "Setup"
            helpEnableExtension = "Enable NewFileMenu Finder Extension in System Settings before the Finder context menu appears."
            helpRestartFinder = "If the menu does not refresh, restart Finder or run the main app again, then check the Finder Extension status."
            folderPanelTitle = "Choose Finder Extension monitored folders"
            newTextFile = "New Text File"
            newFile = "New File"
            textDocument = "Text Document"
        case .simplifiedChinese:
            openSettings = "打开设置"
            quitApp = "退出 NewFileMenu"
            statusTitle = "当前状态"
            fileDefaultsTitle = "默认文件"
            monitoredFoldersTitle = "监控目录"
            add = "添加"
            remove = "删除"
            restoreDefaultFolders = "恢复默认目录"
            defaultBaseName = "默认文件名"
            defaultExtension = "默认扩展名"
            defaultContent = "默认文件内容"
            finderMenuBehaviorTitle = "Finder 菜单行为"
            revealAfterCreate = "创建后选中文件"
            preferSubmenu = "优先使用子菜单"
            menuLanguage = "菜单语言"
            helpTitle = "启用说明"
            helpEnableExtension = "在 System Settings 中启用 NewFileMenu Finder Extension 后，Finder 右键菜单才会出现。"
            helpRestartFinder = "如果菜单没有刷新，可以重启 Finder，或重新运行主 App 后再检查 Finder Extension 状态。"
            folderPanelTitle = "选择 Finder Extension 监控目录"
            newTextFile = "新建文本文件"
            newFile = "新建文件"
            textDocument = "文本文档"
        case .traditionalChinese:
            openSettings = "開啟設定"
            quitApp = "結束 NewFileMenu"
            statusTitle = "目前狀態"
            fileDefaultsTitle = "預設檔案"
            monitoredFoldersTitle = "監控目錄"
            add = "新增"
            remove = "刪除"
            restoreDefaultFolders = "還原預設目錄"
            defaultBaseName = "預設檔案名稱"
            defaultExtension = "預設副檔名"
            defaultContent = "預設檔案內容"
            finderMenuBehaviorTitle = "Finder 選單行為"
            revealAfterCreate = "建立後選取檔案"
            preferSubmenu = "優先使用子選單"
            menuLanguage = "選單語言"
            helpTitle = "啟用說明"
            helpEnableExtension = "在 System Settings 中啟用 NewFileMenu Finder Extension 後，Finder 右鍵選單才會出現。"
            helpRestartFinder = "如果選單沒有重新整理，可以重啟 Finder，或重新執行主 App 後再檢查 Finder Extension 狀態。"
            folderPanelTitle = "選擇 Finder Extension 監控目錄"
            newTextFile = "新增文字檔"
            newFile = "新增檔案"
            textDocument = "文字文件"
        }
    }
}
