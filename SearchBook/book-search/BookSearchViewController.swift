//
//  BookSearchViewController.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import UIKit
import Combine

final class BookSearchViewController: UICollectionViewController, APIRequestable {
    
    // MARK: - View
    private var textField: UITextField!
    private var confirmButton: UIButton!
    private(set) var errorLabel: UILabel!
    
    var requestState = RequestState()
    
    // MARK: - CollectionView
    private var dataSource: UICollectionViewDiffableDataSource<Section, SimpleBook.ID>!
    
    private enum Section: Int {
        case main
    }
    
    private(set) var datas: [SimpleBook] = []
    
    private var recentQuery: String?
    
    /// page 에 대한 응답이 비어있을 경우 다음 page 요청을 추가로 보내지 않기 위한 flag
    private(set) var allPageRead = false
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        setupView()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        setupView()
        configureDataSource()
    }
    
    private func setupView() {
        view.backgroundColor = .white

        let stackView = UIStackView()
        stackView.distribution = .fill
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let textField = UITextField()
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "Search"
        stackView.addArrangedSubview(textField)
        self.textField = textField
        
        let errorLabel = UILabel()
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
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.setContentHuggingPriority(.required, for: .horizontal)
        confirmButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        confirmButton.addTarget(self, action: #selector(comfirmButtonPressed), for: .touchUpInside)
        stackView.addArrangedSubview(confirmButton)
        self.confirmButton = confirmButton
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func comfirmButtonPressed() {
        textField.resignFirstResponder()
        requestFirstPage()
    }
    
    // MARK: - APIRequestable
    
    func requestPublisher(page: Int) -> AnyPublisher<BookSearchResponse, APIError> {
        let query = page == 1 ? textField.text : recentQuery
        recentQuery = query
        return BookSearchRequest(query: query ?? "", page: page).publisher()
    }
    
    func handleResponse(_ response: BookSearchResponse, page: Int) {
        errorLabel.isHidden = true
        
        if page == 1 {
            collectionView.setContentOffset(.zero, animated: false)
            datas = []
        }
        if let books = response.books, !books.isEmpty {
            allPageRead = false
            datas.append(contentsOf: books)
        } else {
            allPageRead = true
        }
        
        if datas.isEmpty {
            errorLabel.isHidden = false
            errorLabel.text = "No Results"
        }
        
        reloadData()
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SimpleBook.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(datas.map({ $0.id }), toSection: .main)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    func handleError(_ error: APIError) {
        datas = []
        
        errorLabel.isHidden = false
        errorLabel.text = "Error ocurred"
        
        collectionView.reloadData()
    }
}

// MARK: - CollectionView
extension BookSearchViewController: UICollectionViewDelegateFlowLayout {
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<SimpleBookCell, SimpleBook> { cell, indexPath, book in
            cell.bind(book)
        }
        
        dataSource = .init(collectionView: collectionView) { [weak self] collectionView, indexPath, identifier -> UICollectionViewCell in
            let item = self?.datas[safe: indexPath.item]
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        collectionView.dataSource = dataSource
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = datas[safe: indexPath.item]?.isbn13 else { return }
        present(BookDetailViewController(isbn13: selectedItem), animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 무한 스크롤
        if indexPath.item == datas.count - 1 && !allPageRead {
            requestNextPage()
        }
    }
}
