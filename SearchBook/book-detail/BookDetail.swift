//
//  BookDetail.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import Foundation

struct BookDetail: Decodable {
    let title: String?
    let subtitle: String?
    let authors: String?
    let publisher: String?
    let isbn10: String?
    let isbn13: String?
    let pages: String?
    let year: String?
    let rating: String?
    let desc: String?
    let price: String?
    let image: String?
    let url: String?
    let pdf: BookDetailPdf?
}

struct BookDetailPdf: Decodable {
    let parsedDatas: [String: String]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var temp: [String: String] = [:]
        
        for key in container.allKeys {
            let value = try container.decode(String.self, forKey: key)
            temp[key.stringValue] = value
        }
        
        parsedDatas = temp
    }
}
