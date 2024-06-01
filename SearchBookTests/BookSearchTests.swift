//
//  BookSearchTests.swift
//  SearchBookTests
//
//  Created by 김가영 on 6/1/24.
//

import XCTest

final class BookSearchTests: XCTestCase {

    override func setUpWithError() throws {
    }

    func testSuccessfulFirstPageLoading() {
        // given
        let firstPageResponse = BookSearchResponse(page: 1, books: SimpleBook.mockDatas)
        let sut = BookSearchViewController()
        
        // when
        sut.handleResponse(firstPageResponse, page: 1)
        
        // then
        XCTAssertTrue(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.datas.count, 5)
        XCTAssertFalse(sut.allPageRead)
    }
    
    func testSuccessfulPaging() {
        // given
        let firstPageResponse = BookSearchResponse(page: 1, books: SimpleBook.mockDatas)
        let sut = BookSearchViewController()
        
        let secondPageResponse = BookSearchResponse(page: 2, books: SimpleBook.mockDatas2)
        
        // when
        sut.handleResponse(firstPageResponse, page: 1)
        sut.handleResponse(secondPageResponse, page: 2)
        
        // then
        XCTAssertTrue(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.datas.count, 10)
        XCTAssertFalse(sut.allPageRead)
    }
    
    func testSuccessfulPagingUntilNilResponse() {
        // given
        let firstPageResponse = BookSearchResponse(page: 1, books: SimpleBook.mockDatas)
        let secondPageResponse = BookSearchResponse(page: 2, books: SimpleBook.mockDatas2)
        let thirdPageResponse = BookSearchResponse(page: 3, books: nil)
        
        let sut = BookSearchViewController()
        
        // when
        sut.handleResponse(firstPageResponse, page: 1)
        sut.handleResponse(secondPageResponse, page: 2)
        sut.handleResponse(thirdPageResponse, page: 3)
        
        // then
        XCTAssertTrue(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.datas.count, 10)
        XCTAssertTrue(sut.allPageRead)
    }
    
    func testSuccessfulPagingUntilEmptyResponse() {
        // given
        let firstPageResponse = BookSearchResponse(page: 1, books: SimpleBook.mockDatas)
        let secondPageResponse = BookSearchResponse(page: 2, books: SimpleBook.mockDatas2)
        let thirdPageResponse = BookSearchResponse(page: 3, books: [])
        
        let sut = BookSearchViewController()
        
        // when
        sut.handleResponse(firstPageResponse, page: 1)
        sut.handleResponse(secondPageResponse, page: 2)
        sut.handleResponse(thirdPageResponse, page: 3)
        
        // then
        XCTAssertTrue(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.datas.count, 10)
        XCTAssertTrue(sut.allPageRead)
    }
    
    func testFirstPageError() {
        // given
        let sut = BookSearchViewController()
        
        // when
        sut.handleError(.unknown)
        
        // then
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.errorLabel.text, "Error ocurred")
        XCTAssertEqual(sut.datas.count, 0)
        XCTAssertFalse(sut.allPageRead)
    }
    
    func testSecondPageError() {
        // given
        let firstPageResponse = BookSearchResponse(page: 1, books: SimpleBook.mockDatas)
        let secondPageResponse = BookSearchResponse(page: 2, books: SimpleBook.mockDatas2)
        let sut = BookSearchViewController()
        
        // when
        sut.handleResponse(firstPageResponse, page: 1)
        sut.handleError(.unknown)
        
        // then
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.errorLabel.text, "Error ocurred")
        XCTAssertEqual(sut.datas.count, 0)
        XCTAssertFalse(sut.allPageRead)
    }
    
    func testFirstPageEmptyResponse() {
        // given
        let emptyResponse = BookSearchResponse(page: 1, books: [])
        let sut = BookSearchViewController()
        
        // when
        sut.handleResponse(emptyResponse, page: 1)
        
        // then
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.errorLabel.text, "No Results")
        XCTAssertEqual(sut.datas.count, 0)
        XCTAssertTrue(sut.allPageRead)
    }
    
    func testFirstPageNilResponse() {
        // given
        let emptyResponse = BookSearchResponse(page: 1, books: nil)
        let sut = BookSearchViewController()
        
        // when
        sut.handleResponse(emptyResponse, page: 1)
        
        // then
        XCTAssertFalse(sut.errorLabel.isHidden)
        XCTAssertEqual(sut.errorLabel.text, "No Results")
        XCTAssertEqual(sut.datas.count, 0)
        XCTAssertTrue(sut.allPageRead)
    }
}

// MARK: - Mock
private extension SimpleBook {
    static var mockDatas: [SimpleBook] {
        [SimpleBook(title: "해리포터", subtitle: "불의잔", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터2", subtitle: "마법사의 돌", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터3", subtitle: "불의잔", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터4", subtitle: "마법사의 돌", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터5", subtitle: "아즈카반의 죄수", isbn13: "abc", price: "3000원", image: nil, url: nil)]
    }
    
    static var mockDatas2: [SimpleBook] {
        [SimpleBook(title: "해리포터6", subtitle: "불의잔", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터7", subtitle: "마법사의 돌", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터8", subtitle: "불의잔", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터9", subtitle: "마법사의 돌", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터10", subtitle: "아즈카반의 죄수", isbn13: "abc", price: "3000원", image: nil, url: nil)]
    }
}
