//
//  DynamicCodingKeys.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import Foundation

// 사전에 정의되지 않은 임의의 문자열을 키로 이용하기 위해 추가됨
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}
