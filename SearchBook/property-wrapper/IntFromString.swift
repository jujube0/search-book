//
//  IntFromString.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import Foundation

@propertyWrapper
struct IntFromString: Decodable {
    var wrappedValue: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        wrappedValue = Int(stringValue)
    }
}
