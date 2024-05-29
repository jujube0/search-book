//
//  SimpleBook.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import Foundation

class SimpleBook: Decodable {
    let title: String?
    let subtitle: String?
    let isbn13: String?
    let price: String?
    let image: String?
    let url: String?
    
    init(title: String?, subtitle: String?, isbn13: String?, price: String?, image: String?, url: String?) {
        self.title = title
        self.subtitle = subtitle
        self.isbn13 = isbn13
        self.price = price
        self.image = image
        self.url = url
    }
}

// MARK: - Mock
extension SimpleBook {
    static var mockDatas: [SimpleBook] {
        [SimpleBook(title: "해리포터", subtitle: "불의잔", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터2", subtitle: "마법사의 돌", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터3", subtitle: "불의잔", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터4", subtitle: "마법사의 돌", isbn13: "abc", price: "3000원", image: nil, url: nil),
         SimpleBook(title: "해리포터5", subtitle: "아즈카반의 죄수", isbn13: "abc", price: "3000원", image: nil, url: nil)]
    }
}
