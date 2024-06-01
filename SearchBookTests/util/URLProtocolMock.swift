//
//  URLProtocolMock.swift
//  SearchBookTests
//
//  Created by 김가영 on 6/1/24.
//

import Foundation

final class URLProtocolMock: URLProtocol {
    static var testURLs = [URL?: Data]()
    
    // 모든 종류의 request를 지원
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        if let url = request.url, let data = Self.testURLs[url] {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        // do nothing
    }
}
