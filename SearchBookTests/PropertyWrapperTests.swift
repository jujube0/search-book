//
//  PropertyWrapperTests.swift
//  SearchBookTests
//
//  Created by 김가영 on 6/1/24.
//

import XCTest

final class PropertyWrapperTests: XCTestCase {
    
    func testSuccessfulIntTypeStringDecoding() {
        
        // given
        struct TestStruct: Decodable {
            @IntFromString var intTypeString: Int?
        }
        
        let data = """
            {
                "intTypeString": "1"
            }
        """.data(using: .utf8)
        
        // when
        guard let data,
              let decoded = try? JSONDecoder().decode(TestStruct.self, from: data) else {
            XCTFail("decoding failed")
            return
        }
        
        // then
        XCTAssertEqual(decoded.intTypeString, 1)
    }
    
    func testFailingIntTypeIntDecoding() {
        // given
        struct TestStruct: Decodable {
            @IntFromString var intTypeInt: Int?
        }
        
        let data = """
            {
                "intTypeInt": 1
            }
        """.data(using: .utf8)
        
        // when
        guard let data else {
            XCTFail()
            return
        }
        let decoded = try? JSONDecoder().decode(TestStruct.self, from: data)
        
        // then
        XCTAssertNil(decoded)
    }
    
    func testFailingStringTypeStringDecoding() {
        // given
        struct TestStruct: Decodable {
            @IntFromString var stringTypeString: Int?
        }
        
        let data = """
            {
                "stringTypeString": "some"
            }
        """.data(using: .utf8)
        
        // when
        guard let data else {
            XCTFail()
            return
        }
        let decoded = try? JSONDecoder().decode(TestStruct.self, from: data)
        
        // then
        XCTAssertNil(decoded)
    }
    
    func testFailingFloatTypeStringDecoding() {
        // given
        struct TestStruct: Decodable {
            @IntFromString var floatTypeString: Int?
        }
        
        let data = """
            {
                "floatTypeString": "1.0"
            }
        """.data(using: .utf8)
        
        // when
        guard let data else {
            XCTFail()
            return
        }
        let decoded = try? JSONDecoder().decode(TestStruct.self, from: data)
        
        // then
        XCTAssertNil(decoded)
    }
    
    func testFailingFloatTypeStringFloat() {
        // given
        struct TestStruct: Decodable {
            @IntFromString var floatTypeString: Int?
        }
        
        let data = """
            {
                "floatTypeString": 1.0
            }
        """.data(using: .utf8)
        
        // when
        guard let data else {
            XCTFail()
            return
        }
        let decoded = try? JSONDecoder().decode(TestStruct.self, from: data)
        
        // then
        XCTAssertNil(decoded)
    }
}
