//
//  PDFViewController.swift
//  SearchBook
//
//  Created by 김가영 on 5/31/24.
//

import UIKit
import PDFKit

final class PDFViewController: UIViewController {
    
    let urlString: String
    
    // MARK: - View
    var pdfView: PDFView!
    var errorLabel: UILabel!
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        loadPDF()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.topAnchor.constraint(equalTo: view.topAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.pdfView = pdfView
        
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
    
    private func loadPDF() {
        
        let completionHandler: ((Bool) -> Void) = { [weak self] success in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                strongSelf.pdfView.isHidden = !success
                strongSelf.errorLabel.isHidden = success
            }
        }
        
        guard let url = URL(string: urlString) else {
            completionHandler(false)
            return
        }
        
        DispatchQueue.global().async {
            guard let document = PDFDocument(url: url) else {
                completionHandler(false)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.pdfView.document = document
                completionHandler(true)
            }
        }
    }
}
