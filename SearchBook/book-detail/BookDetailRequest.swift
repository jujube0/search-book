//
//  BookDetailRequest.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import Foundation
import Combine

struct BookDetailRequest: APIRequest {
    typealias ResponseType = BookDetail
    var baseURL: URL = URL(string: "https://api.itbook.store/1.0/books")!
    
    let isbn: String
    
    init(isbn: String) {
        self.isbn = isbn
    }
    
    func publisher() -> AnyPublisher<ResponseType, APIError> {
        publisher(path: "/\(isbn)", parameters: nil)
    }
}
