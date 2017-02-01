import XCTest
@testable import Bencode

class BencodeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }
    
    // MARK: Integers
    func testShouldDecodeInteger() {
        let data = "i123e".data(using: .utf8)!
        
        let result = try? Bencode.decode(data: data) as! Int
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 123)
    }
    
    func testShouldDecodeNegativeInteger() {
        let data = "i-345e".data(using: .utf8)!
        let result = try? Bencode.decode(data: data) as! Int
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, -345)
    }
    
    func testShouldAllowZero() {
        let data = "i0e".data(using: .utf8)!
        let result = try? Bencode.decode(data: data) as! Int
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 0)
    }
    
    func testShouldThrowIfFormatIsInvalid() {
        // TODO: According to specification these should be invalid
        
        // let data1 = "i-0e".data(using: .utf8)!
        // XCTAssertThrowsError(try Bencode.decode(data: data1))
        
        // let data2 = "i03e".data(using: .utf8)!
        // XCTAssertThrowsError(try Bencode.decode(data: data2))
        
        let data3 = "ie".data(using: .utf8)!
        XCTAssertThrowsError(try Bencode.decode(data: data3))
        
        let data4 = "i12.345e".data(using: .utf8)!
        XCTAssertThrowsError(try Bencode.decode(data: data4))
    }
    
    // MARK: Buffers
    func testShouldDecodeBuffer() {
        let data = "5:asdfe".data(using: .utf8)!
        let result = try? Bencode.decode(data: data) as! Data
        let stringified = String(data: result!, encoding: .utf8)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(stringified, "asdfe")
    }
    
    func testShouldDecodeEmptyBuffer() {
        let data = "0:".data(using: .utf8)!
        
        let result = try? Bencode.decode(data: data) as! Data
        let stringified = String(data: result!, encoding: .utf8)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(stringified, "")
    }
    
    // MARK: Dictionaries
    func testShouldDecodeDictionary() {
        let data = "d3:cow3:moo4:spam4:eggse".data(using: .utf8)!
        let result = try? Bencode.decode(data: data) as! [String: Data]
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, ["cow": "moo".data(using: .utf8)!, "spam": "eggs".data(using: .utf8)!])
    }
    
    func testShouldDecodeStuffInDictionary() {
        let data = "d4:spaml1:a1:bee".data(using: .utf8)!
        let result = try? Bencode.decode(data: data) as! [String: Any]
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!["spam"] as! [Data], ["a".data(using: .utf8)!, "b".data(using: .utf8)!])
    }
    
    func testShouldDecodeEmptyDictionary() {
        let data = "de".data(using: .utf8)!
        let result = try? Bencode.decode(data: data) as! [String: Data]
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, [:])
    }
    
    // MARK: Lists
    func testShouldDecodeList() {
        let data = "l4:spam4:eggse".data(using: .utf8)!
        let result = try? Bencode.decode(data: data) as! [Data]
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, ["spam".data(using: .utf8)!, "eggs".data(using: .utf8)!])
    }
    
    func testShouldDecodeEmptyList() {
        let data = "le".data(using: .utf8)!
        let result = try? Bencode.decode(data: data) as! [Data]
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, [])
    }

    // MARK: allTests
    static let allTests = [
        ("testShouldDecodeInteger", testShouldDecodeInteger),
        ("testShouldDecodeNegativeInteger", testShouldDecodeNegativeInteger),
        ("testShouldAllowZero", testShouldAllowZero),
        ("testShouldThrowIfFormatIsInvalid", testShouldThrowIfFormatIsInvalid),
        
        ("testShouldDecodeBuffer", testShouldDecodeBuffer),
        ("testShouldDecodeEmptyBuffer", testShouldDecodeEmptyBuffer),
        
        ("testShouldDecodeDictionary", testShouldDecodeDictionary),
        ("testShouldDecodeStuffInDictionary", testShouldDecodeStuffInDictionary),
        ("testShouldDecodeEmptyDictionary", testShouldDecodeEmptyDictionary),
        
        ("testShouldDecodeList", testShouldDecodeList),
        ("testShouldDecodeEmptyList", testShouldDecodeEmptyList)
    ]
}
