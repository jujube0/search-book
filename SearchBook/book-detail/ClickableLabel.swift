//
//  ClickableLabel.swift
//  SearchBook
//
//  Created by 김가영 on 5/31/24.
//

import UIKit

final class ClickableLabel: UILabel {
    
    var pressHandler: ((ClickableLabel) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        textColor = .blue
        
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(labelPressed))
        addGestureRecognizer(tap)
    }
    
    @objc func labelPressed() {
        pressHandler?(self)
    }
}
