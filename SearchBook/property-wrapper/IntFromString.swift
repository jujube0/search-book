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
        let wrappedValue = Int(stringValue)
        
        guard let wrappedValue else {
            throw NSError()
        }
        self.wrappedValue = wrappedValue
    }
    
    init(_ wrappedValue: Int?) {
        self.wrappedValue = wrappedValue
    }
}
