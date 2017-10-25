import XCTest
@testable import FwiCore


enum TestEnum: String, Codable {
    case firstName = "first_name"
    case lastName = "last_name"
}

struct Test2: Codable {
    let name: String?
    let last: String?
}
struct Test: Codable {
    let name: String
    let last: String
    let age: UInt
    var enumValue: TestEnum
    var object: [String:String]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        container.decode(<#T##type: Bool.Type##Bool.Type#>, forKey: <#T##Test.CodingKeys#>)
//        let key = Test.CodingKeys.last

        enumValue = try container + .enumValue
        object = try container + .object
        name = container + .name
        last = container + .last
        age = container + .age
    }
}

class FwiCoreTests: XCTestCase {
    func testExample() {
        let text = "{\"name\":\"Phuc\",\"last\":\"Tran\",\"age\":\"10\",\"enumValue\":\"last_name\", \"object\":{\"name\":\"Phuc\",\"last\":\"Tran\"}}"
        let o = Test.decodeJSON(text.toData())
        
        debugPrint(o)
//        let status = FwiNetworkStatus.httpTooManyRedirects
//        let status2 = FwiNetworkStatus(rawValue: 0)
//        FwiLog("\(status.description) \(status2) \(status2.rawValue) \(status2 == status)")
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
