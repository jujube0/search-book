//
//  SimpleBookCell.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import UIKit

final class SimpleBookCell: UICollectionViewCell {
    
    static var reuseIdentifier = "simple-book-cell"
    
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var isbnLabel: UILabel!
    private var priceLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .lightGray
        
        let hStackView = UIStackView()
        hStackView.alignment = .leading
        contentView.addSubview(hStackView)
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.addArrangedSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
        ])
        self.imageView = imageView
        
        let labelStackView = UIStackView()
        labelStackView.axis = .vertical
        hStackView.addArrangedSubview(labelStackView)
        
        let titleLabel = UILabel()
        labelStackView.addArrangedSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let subtitleLabel = UILabel()
        labelStackView.addArrangedSubview(subtitleLabel)
        self.subtitleLabel = subtitleLabel
        
        let isbnLabel = UILabel()
        labelStackView.addArrangedSubview(isbnLabel)
        self.isbnLabel = isbnLabel
        
        let priceLabel = UILabel()
        labelStackView.addArrangedSubview(priceLabel)
        self.priceLabel = priceLabel
    }
    
    func bind(_ item: SimpleBook) {
        imageView.isHidden = true
        titleLabel.setTextHideIfEmpty(item.title)
        subtitleLabel.setTextHideIfEmpty(item.subtitle)
        isbnLabel.setTextHideIfEmpty(item.isbn13.map({ "isbn13: \($0)" }))
        priceLabel.setTextHideIfEmpty(item.price)
    }
}
