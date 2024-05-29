//
//  Collection+Extensions.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
