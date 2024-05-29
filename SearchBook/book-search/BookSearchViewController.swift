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
    
    private var datas: [SimpleBook] = []
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        setupView()
        registerCells()
        // TODO: remove code
        datas = SimpleBook.mockDatas
    }
    
    required init?(coder: NSCoder) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white

        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let textField = UITextField()
        textField.placeholder = "검색어를 입력해주세요"
        stackView.addArrangedSubview(textField)
        self.textField = textField
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("확인", for: .normal)
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
        // TODO: 서버 요청
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
            cell.titleLabel.text = item.title
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 상세 페이지
    }
}
