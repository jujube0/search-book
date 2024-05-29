//
//  BookSearchRequest.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import Foundation
import Combine

struct BookSearchRequest: APIRequest {
    typealias ResponseType = BookSearchResponse
    var baseURL: URL = URL(string: "https://api.itbook.store/1.0/search")!
    
    let query: String
    let page: Int
    
    init(query: String, page: Int = 0) {
        self.query = query
        self.page = page
    }
    
    func publisher() -> AnyPublisher<ResponseType, APIError> {
        publisher(path: "/\(query)/\(page)", parameters: nil)
    }
}

struct BookSearchResponse: Decodable {
    @IntFromString
    var total: Int?
    
    @IntFromString
    var page: Int?
    
    let books: [SimpleBook]?
}

