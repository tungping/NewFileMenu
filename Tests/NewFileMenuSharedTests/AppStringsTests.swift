import XCTest
@testable import NewFileMenuShared

final class AppStringsTests: XCTestCase {
    func testFinderMenuLabelsSupportConfiguredLanguages() {
        XCTAssertEqual(AppStrings(language: .english).newTextFile, "New Text File")
        XCTAssertEqual(AppStrings(language: .simplifiedChinese).newTextFile, "新建文本文件")
        XCTAssertEqual(AppStrings(language: .traditionalChinese).newTextFile, "新增文字檔")
    }

    func testMenuLanguageContainsOnlySupportedLanguages() {
        XCTAssertEqual(MenuLanguage.allCases, [
            .english,
            .simplifiedChinese,
            .traditionalChinese
        ])
    }
}
