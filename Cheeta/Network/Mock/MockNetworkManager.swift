//
//  MockNetworkManager.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 07/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import UIKit

class MockNetworkManager: NetworkManagerInitializable {
    
    static var shared: NetworkManagerInitializable {
        return MockNetworkManager(session: MockedURLSession())
    }
    var session: URLSessionProtocol
    
    required init(session: URLSessionProtocol) {
        self.session = session
    }
}


// We create a partial mock by subclassing the original class
class URLSessionDataTaskMock: URLSessionTaskProtocol {
    func cancel() {}
    func suspend() {}
    func resume() {
        completion()
    }
    private var completion: () -> Void
    init(completion: @escaping (() -> Void)){
        self.completion = completion
    }
}


class MockedURLSession: URLSessionProtocol {
    
    var data: Data?
    var httpResponse: HTTPURLResponse?
    var error: Error?
    
    static var shared = MockedURLSession()
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTaskProtocol {
        let mockDataTask = URLSessionDataTaskMock {
            completionHandler(self.data, self.httpResponse, self.error)
        }
        return mockDataTask
    }
}
