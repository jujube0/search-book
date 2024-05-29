//
//  SimpleBookCell.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import UIKit

final class SimpleBookCell: UICollectionViewCell {
    
    static var reuseIdentifier = "simple-book-cell"
    
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .orange
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        self.titleLabel = titleLabel
    }
}
