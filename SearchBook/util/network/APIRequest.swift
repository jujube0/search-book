//
//  APIRequest.swift
//  SearchBook
//
//  Created by 김가영 on 5/29/24.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    case unknown
}

protocol APIRequest {
    associatedtype ResponseType: Decodable
    
    var urlSession: URLSession { get }
    
    var baseURL: URL { get }
    
    func publisher(path: String, parameters: [String: String]?) -> AnyPublisher<ResponseType, APIError>
}

extension APIRequest {
    func publisher(path: String, parameters: [String: String]?) -> AnyPublisher<ResponseType, APIError> {
        guard let urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false),
              let url = urlComponents.url else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url)
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .mapError { _ in
                APIError.unknown
            }
            .decode(type: ResponseType.self, decoder: JSONDecoder())
            .mapError { _ in
                APIError.decodingFailed
            }
            .eraseToAnyPublisher()
    }
}
