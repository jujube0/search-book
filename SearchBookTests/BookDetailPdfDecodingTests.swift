//
//  BookDetailPdfDecodingTests.swift
//  SearchBookTests
//
//  Created by 김가영 on 6/1/24.
//

import XCTest

final class BookDetailPdfDecodingTests: XCTestCase {
    
    func testSuccessfulDecoding() {
        
        // given
        let data = """
            {
              "Chapter 2": "https://itbook.store/files/9781617294136/chapter2.pdf",
              "Chapter 5": "https://itbook.store/files/9781617294136/chapter5.pdf"
            }
        """.data(using: .utf8)
        
        // when
        let decoded = try? JSONDecoder().decode(BookDetailPdf.self, from: data!)
        
        // then
        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded?.parsedDatas?.count, 2)
        
        XCTAssertEqual(decoded?.parsedDatas?["Chapter 2"], "https://itbook.store/files/9781617294136/chapter2.pdf")
        XCTAssertEqual(decoded?.parsedDatas?["Chapter 5"], "https://itbook.store/files/9781617294136/chapter5.pdf")
    }
}
