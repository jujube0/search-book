//
//  APIRequestable.swift
//  SearchBook
//
//  Created by 김가영 on 6/1/24.
//

import UIKit
import Combine

protocol APIRequestable: NSObject {
    associatedtype ResponseType
    
    var requestState: RequestState { get set }
    
    func requestPublisher(page: Int) -> AnyPublisher<ResponseType, APIError>
    
    func handleResponse(_ response: ResponseType, page: Int)
    
    func handleError(_ error: APIError)
}

extension APIRequestable {
    func requestFirstPage() {
        request(page: 1)
    }
    
    func requestNextPage() {
        if requestState.status == .finished {
            request(page: requestState.page + 1)
        }
    }
    
    func request(page: Int) {
        guard requestState.status != .loading else { return }
        requestState.status = .loading
        requestState.page = page
        
        requestState.requestCancellable = requestPublisher(page: page)
            .sink(receiveCompletion: { [weak self] result in
                guard let strongSelf = self else { return }
                if case .failure(let failure) = result {
                    DispatchQueue.main.async {
                        strongSelf.handleError(failure)
                    }
                    strongSelf.requestState.status = .failed
                } else {
                    strongSelf.requestState.status = .finished
                }
            }, receiveValue: { [weak self] response in
                DispatchQueue.main.async {
                    self?.handleResponse(response, page: page)
                }
            })
    }
}
