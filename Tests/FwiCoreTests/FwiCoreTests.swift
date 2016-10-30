import XCTest
@testable import FwiCore


class FwiCoreTests: XCTestCase {
    func testExample() {
//        let status = FwiNetworkStatus.InternalServerError
//        let status2 = FwiNetworkStatus(rawValue: 500)
//        FwiLog("\(status) \(status.rawValue) \(status2.rawValue) \(status2 == status)")
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
////        XCTAssertEqual(FwiCore.text, "Hello, World!")
    }

    
    static var allTests : [(String, (FwiCoreTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
