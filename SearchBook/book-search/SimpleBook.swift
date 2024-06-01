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

