//
//  UILabel+Extensions.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import UIKit

extension UILabel {
    func setTextHideIfEmpty(_ text: String?) {
        if let text, !text.isEmpty {
            self.text = text
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }
}
