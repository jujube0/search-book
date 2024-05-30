//
//  BookSearchViewController.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import UIKit
import Combine

final class BookSearchViewController: UICollectionViewController {
    // MARK: - View
    private var textField: UITextField!
    private var confirmButton: UIButton!
    private var errorLabel: UILabel!
    
    private var requestState = RequestState()
    private var datas: [SimpleBook] = []
    
    private var recentQuery: String?
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        setupView()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        setupView()
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
    
    private func requestFirstPage() {
        request(page: 1)
    }
    
    private func requestNextPage() {
        guard requestState.status == .finished(allPagesRead: false) else { return }
        request(page: requestState.page + 1)
    }
}

// MARK: - CollectionView
extension BookSearchViewController: UICollectionViewDelegateFlowLayout {
    
    private func registerCells() {
        collectionView.register(SimpleBookCell.self, forCellWithReuseIdentifier: SimpleBookCell.reuseIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datas.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimpleBookCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? SimpleBookCell, let item = datas[safe: indexPath.item] {
            cell.bind(item)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = datas[safe: indexPath.item]?.isbn13 else { return }
        present(BookDetailViewController(isbn13: selectedItem), animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 무한 스크롤
        if indexPath.item == datas.count - 1 {
            requestNextPage()
        }
    }
}

// MARK: - Network
extension BookSearchViewController {
    private func request(page: Int) {
        guard requestState.status != .loading else { return }
        
        requestState.status = .loading
        
        let completion: ((RequestState.Status) -> Void) = { [weak self] status in
            guard let strongSelf = self else { return }
            strongSelf.requestState.status = status
            
            var errorMessage: String?
            
            switch status {
            case .finished(_):
                if strongSelf.datas.isEmpty {
                    errorMessage = "No Result"
                }
            default:
                strongSelf.datas = []
                strongSelf.requestState.page = 0
                errorMessage = "Network Failed"
            }
            
            DispatchQueue.main.async {
                if let errorMessage {
                    self?.errorLabel.text = errorMessage
                    self?.errorLabel.isHidden = false
                } else {
                    self?.errorLabel.isHidden = true
                }
                self?.collectionView.reloadData()
            }
        }
        
        // 첫번째 페이지라면 새로운 쿼리로 요청
        let query = page == 1 ? textField.text : recentQuery
        requestState.page = page
        recentQuery = query
        
        guard let query, !query.isEmpty else {
            datas = []
            completion(.finished(allPagesRead: true))
            return
        }
        
        
        requestState.requestCancellable = BookSearchRequest(query: query, page: page)
            .publisher()
            .sink(receiveCompletion: { result in
                if case .failure = result {
                    completion(.failed)
                }
            }, receiveValue: { [weak self, completion] response in
                guard let strongSelf = self else { return }
                
                if page == 1 {
                    strongSelf.datas = response.books ?? []
                } else {
                    strongSelf.datas.append(contentsOf: response.books ?? [])
                }
                
                let allPagesRead: Bool
                if let total = response.total {
                    allPagesRead = strongSelf.datas.count >= total
                } else {
                    allPagesRead = false
                }
                
                completion(.finished(allPagesRead: allPagesRead))
            })
    }
}
