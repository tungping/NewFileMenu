import XCTest
@testable import NewFileMenuShared

final class FileCreatorTests: XCTestCase {
    func testCreatesFileWithConfiguredContent() throws {
        let directory = try TemporaryDirectory()

        let url = try FileCreator.createFile(
            in: directory.url,
            baseName: "Note",
            fileExtension: "txt",
            content: "hello"
        )

        XCTAssertEqual(url.lastPathComponent, "Note.txt")
        XCTAssertEqual(try String(contentsOf: url, encoding: .utf8), "hello")
    }

    func testCreatesUniqueFileWhenDefaultNameExists() throws {
        let directory = try TemporaryDirectory()
        FileManager.default.createFile(
            atPath: directory.url.appendingPathComponent("Note.txt").path,
            contents: nil
        )

        let url = try FileCreator.createFile(
            in: directory.url,
            baseName: "Note",
            fileExtension: "txt",
            content: ""
        )

        XCTAssertEqual(url.lastPathComponent, "Note 2.txt")
        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
}
