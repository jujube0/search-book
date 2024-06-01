//
//  RequestState.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import Foundation
import Combine

struct RequestState {
    enum Status: Equatable {
        case initialized
        case loading
        case finished
        case failed
    }
    
    var status: Status = .initialized
    
    var page = 1
    
    var requestCancellable: AnyCancellable?
}
