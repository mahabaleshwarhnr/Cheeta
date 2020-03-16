//
//  MockNetworkManager.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 07/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import UIKit

protocol URLSessionProtocol: class {
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol: class {
    func resume()
}

// We create a partial mock by subclassing the original class
class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
   
    func resume() {
        completion()
    }
    private var completion: () -> Void
    init(completion: @escaping (() -> Void)){
        self.completion = completion
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSession: URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return self.dataTask(with: request, completionHandler: completionHandler)
    }
}

class MockedURLSession: URLSessionProtocol {
    
    var data: Data?
    var httpResponse: HTTPURLResponse?
    var error: Error?
    
    static var shared: MockedURLSession {
        return MockedURLSession()
    }
    
    public init() {
        
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let mockedDataTask = URLSessionDataTaskMock { [weak self] in
            completionHandler(self?.data, self?.httpResponse, self?.error)
        }
        return mockedDataTask
    }
}

//class MockedProtocol: URLProtocol {
//
//    static var mockedResponseTuple: (data: Data?, httpResponse: HTTPURLResponse?, error: Error?)
//
//    override func startLoading() {
//        let tuple = MockedProtocol.mockedResponseTuple
//        if MockedProtocol.mockedResponseTuple.httpResponse?.isSuccess == true {
//            self.client?.urlProtocol(self, didReceive: tuple.httpResponse!, cacheStoragePolicy: .notAllowed)
//            self.client?.urlProtocol(self, didLoad: tuple.data!)
//            self.client?.urlProtocolDidFinishLoading(self)
//        } else {
//            self.client?.urlProtocol(self, didFailWithError: tuple.error!)
//        }
//    }
//
//    override func stopLoading() {
//
//    }
//
//    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
//        return request
//    }
//
//    override class func canInit(with request: URLRequest) -> Bool {
//        guard let _ = request.url else {
//            return false
//        }
//        return true
//    }
//}
