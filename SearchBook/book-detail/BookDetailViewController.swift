//
//  BookDetailViewController.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import UIKit
import Combine

final class BookDetailViewController: UIViewController {
    let isbn13: String
    
    var cancellable: AnyCancellable?
    
    // MARK: View
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var authorLabel: UILabel!
    
    init(isbn13: String) {
        self.isbn13 = isbn13
        super.init(nibName: nil, bundle: nil)
        setupView()
        request()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        view.backgroundColor = .white

        let stackView = UIStackView()
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let imageView = UIImageView()
        stackView.addArrangedSubview(imageView)
        self.imageView = imageView
        
        let titleLabel = UILabel()
        stackView.addArrangedSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let subtitleLabel = UILabel()
        stackView.addArrangedSubview(subtitleLabel)
        self.subtitleLabel = subtitleLabel
        
        let authorLabel = UILabel()
        stackView.addArrangedSubview(authorLabel)
        self.authorLabel = authorLabel
    }
    
    private func request() {
        cancellable = BookDetailRequest(isbn: isbn13).publisher()
            .sink(receiveCompletion: { result in
                if case .failure = result {
                    print("Error")
                }
            }, receiveValue: { [weak self] item in
                DispatchQueue.main.async {
                    self?.apply(item: item)
                }
            })
    }
    
    private func apply(item: BookDetail) {
        ImageAssetManager().request(item.image.flatMap({ URL(string: $0) })) { image in
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
        
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        authorLabel.text = item.authors
    }
}
