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
        
        let result = try? Bencode.decode(data: data)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.integer, 123)
    }
    
    func testShouldDecodeNegativeInteger() {
        let data = "i-345e".data(using: .utf8)!
        let result = try? Bencode.decode(data: data)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.integer, -345)
    }
    
    func testShouldAllowZero() {
        let data = "i0e".data(using: .utf8)!
        let result = try? Bencode.decode(data: data)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.integer, 0)
    }
    
    func testShouldThrowIfFormatIsInvalid() {
//        TODO: According to specification these should be invalid
        
//        let data1 = "i-0e".data(using: .utf8)!
//        XCTAssertThrowsError(try Bencode.decode(data: data1))
        
//        let data2 = "i03e".data(using: .utf8)!
//        XCTAssertThrowsError(try Bencode.decode(data: data2))
        
        let data3 = "ie".data(using: .utf8)!
        XCTAssertThrowsError(try Bencode.decode(data: data3))
        
//        let data4 = "i12.345e".data(using: .utf8)!        
//        XCTAssertThrowsError(try Bencode.decode(data: data4))
    }
    
    // MARK: Buffers
    func testShouldDecodeBuffer() {
        let data = "5:asdfe".data(using: .utf8)!
        let result = try? Bencode.decode(data: data)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.string, "asdfe")
    }
    
    func testShouldDecodeEmptyBuffer() {
        let data = "0:".data(using: .utf8)!
        
        let result = try? Bencode.decode(data: data)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.string, "")
    }
    
    // MARK: Dictionaries
    func testShouldDecodeDictionary() {
        let data = "d3:cow3:moo4:spam4:eggse".data(using: .utf8)!
        let result = try? Bencode.decode(data: data)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.dictionary?["cow"]?.string, "moo")
        XCTAssertEqual(result?.dictionary?["spam"]?.string, "eggs")
    }
    
    func testShouldDecodeStuffInDictionary() {
        let data = "d4:spaml1:a1:bee".data(using: .utf8)!
        let result = try? Bencode.decode(data: data)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.dictionary?["spam"]?.list?[0].string, "a")
        XCTAssertEqual(result?.dictionary?["spam"]?.list?[1].string, "b")
    }
    
    func testShouldDecodeEmptyDictionary() {
        let data = "de".data(using: .utf8)!
        let result = try? Bencode.decode(data: data)
        
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.dictionary!.isEmpty)
    }
    
    // MARK: Lists
    func testShouldDecodeList() {
        let data = "l4:spam4:eggse".data(using: .utf8)!
        let result = try? Bencode.decode(data: data)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.list?[0].string, "spam")
        XCTAssertEqual(result?.list?[1].string, "eggs")
    }
    
    func testShouldDecodeEmptyList() {
        let data = "le".data(using: .utf8)!
        let result = try? Bencode.decode(data: data)
        
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.list!.isEmpty)
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
