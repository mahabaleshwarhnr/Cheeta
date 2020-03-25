//
//  XCBaseTestCase.swift
//  CheetaTests
//
//  Created by Mahabaleshwar on 24/03/20.
//  Copyright © 2020 TW. All rights reserved.
//

import XCTest
@testable import Cheeta

class XCBaseTestCase: XCTestCase {

    public var mockSession: URLSession!
    public var apiManager: APIManager!
    
    
    
    override func setUp() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        self.mockSession = URLSession(configuration: config, delegate: nil, delegateQueue: .main)
        self.apiManager = APIManager(session: self.mockSession)
        
    }
    
    override func tearDown() {
        mockSession = nil
        apiManager = nil
    }
}

