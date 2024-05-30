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
    var stackView: UIStackView!
    var errorLabel: UILabel!
    
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
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        self.stackView = stackView
        
        let errorLabel = UILabel()
        errorLabel.text = "Failed To Load"
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.isHidden = true
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
            errorLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.errorLabel = errorLabel
    }
    
    private func request() {
        cancellable = BookDetailRequest(isbn: isbn13).publisher()
            .sink(receiveCompletion: { [weak self] result in
                if case .failure = result {
                    self?.errorLabel.isHidden = false
                }
            }, receiveValue: { [weak self] item in
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    strongSelf.errorLabel.isHidden = true
                    strongSelf.apply(item: item)
                }
            })
    }
    
    private func apply(item: BookDetail) {
        if let image = item.image, let url = URL(string: image) {
            let imageView = UIImageView()
            stackView.addArrangedSubview(imageView)
            ImageAssetManager().request(url) { image in
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
        
        stackView.appendLabel(with: item.title, description: "title")
        stackView.appendLabel(with: item.subtitle, description: "subtitle")
        stackView.appendLabel(with: item.authors, description: "authors")
        stackView.appendLabel(with: item.publisher, description: "publisher")
        stackView.appendLabel(with: item.isbn10, description: "isbn10")
        stackView.appendLabel(with: item.isbn13, description: "isbn13")
        stackView.appendLabel(with: item.pages, description: "pages")
        stackView.appendLabel(with: item.year, description: "year")
        stackView.appendLabel(with: item.rating, description: "rating")
        stackView.appendLabel(with: item.desc, description: "desc")
        stackView.appendLabel(with: item.price, description: "price")
        stackView.appendLabel(with: item.url, description: "url")
        
        if let pdfDict = item.pdf?.parsedDatas, !pdfDict.isEmpty {
            stackView.appendLabel(with: "pdfs")
            pdfDict.forEach { key, value in
                stackView.appendClickableLabel(with: " -\(key)") { _ in
                    print("pressed")
                }
            }
        }
    }
}

private extension UIStackView {
    
    func appendLabel(with text: String?, description: String? = nil) {
        guard let text, !text.isEmpty else { return }
        
        let content: String
        if let description {
            content = "\(description): \(text)"
        } else {
            content = "\(text)"
        }
        
        let label = UILabel()
        label.text = content
        label.numberOfLines = 0
        addArrangedSubview(label)
    }
    
    func appendClickableLabel(with text: String, pressHandler: @escaping ((UILabel) -> Void)) {
        let clickableLabel = ClickableLabel()
        clickableLabel.text = text
        clickableLabel.pressHandler = pressHandler
        addArrangedSubview(clickableLabel)
    }
}
