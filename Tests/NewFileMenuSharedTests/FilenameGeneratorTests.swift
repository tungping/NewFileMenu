import XCTest
@testable import NewFileMenuShared

final class FilenameGeneratorTests: XCTestCase {
    func testUsesDefaultFilenameWhenDirectoryIsEmpty() throws {
        let directory = try TemporaryDirectory()

        let url = FilenameGenerator.uniqueFileURL(
            in: directory.url,
            baseName: "New Text File",
            fileExtension: "txt"
        )

        XCTAssertEqual(url.lastPathComponent, "New Text File.txt")
    }

    func testAddsIncreasingSuffixWhenNameAlreadyExists() throws {
        let directory = try TemporaryDirectory()
        FileManager.default.createFile(
            atPath: directory.url.appendingPathComponent("New Text File.txt").path,
            contents: nil
        )
        FileManager.default.createFile(
            atPath: directory.url.appendingPathComponent("New Text File 2.txt").path,
            contents: nil
        )

        let url = FilenameGenerator.uniqueFileURL(
            in: directory.url,
            baseName: "New Text File",
            fileExtension: "txt"
        )

        XCTAssertEqual(url.lastPathComponent, "New Text File 3.txt")
    }

    func testNormalizesBlankBaseNameAndLeadingDotExtension() throws {
        let directory = try TemporaryDirectory()

        let url = FilenameGenerator.uniqueFileURL(
            in: directory.url,
            baseName: "   ",
            fileExtension: ".md"
        )

        XCTAssertEqual(url.lastPathComponent, "untitled.md")
    }
}
