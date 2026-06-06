import XCTest
@testable import NewFileMenuShared

final class AppStringsTests: XCTestCase {
    func testStringsInitialisesCorrectlyForEachLanguage() {
        XCTAssertEqual(AppStrings(language: .english).openSettings, "Open Settings")
        XCTAssertEqual(AppStrings(language: .simplifiedChinese).openSettings, "打开设置")
        XCTAssertEqual(AppStrings(language: .traditionalChinese).openSettings, "開啟設定")
    }

    func testMenuLanguageContainsOnlySupportedLanguages() {
        XCTAssertEqual(MenuLanguage.allCases, [
            .english,
            .simplifiedChinese,
            .traditionalChinese
        ])
    }
}
