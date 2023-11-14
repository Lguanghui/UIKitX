import XCTest
@testable import UIKitX

final class UIKitXTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }
    
    func testInsetLabelAPI() throws {
        let label = UXInsetLabel(contentInset: .init(top: 2, left: 3, bottom: 2, right: 3))
        print(label.contentInset)
    }
}
