//
//  MockURLProtocol.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 24/03/20.
//  Copyright © 2020 TW. All rights reserved.
//

import Foundation

class MockURLProtocol: URLProtocol {

    // 1. Handler to test the request and return mock response.
    static var mockResponseHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    static var delay: DispatchTimeInterval = .milliseconds(0)
    
    private var cancelledOrComplete: Bool = false
    private var workItem: DispatchWorkItem?
    private static let queue = DispatchQueue.global(qos: .userInitiated)
    

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        
        workItem = DispatchWorkItem(block: { [weak self] in
            if self?.cancelledOrComplete == false {
                self?.finishRequest()
            }
            self?.cancelledOrComplete = true
        })
        
        MockURLProtocol.queue.asyncAfter(deadline: .now() + MockURLProtocol.delay, execute: workItem!)
    }
    
    override func stopLoading() {
        MockURLProtocol.queue.async {
            if self.cancelledOrComplete == false, let workItem = self.workItem {
                workItem.cancel()
                self.cancelledOrComplete = true
            }
        }
    }
    
    private func finishRequest() {
        guard let handler = MockURLProtocol.mockResponseHandler else {
            return
        }
        
        do {
            // 2. Call handler with received request and capture the tuple of response and data.
            let (response, data) = try handler(request)
            
            // 3. Send received response to the client.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = data {
                // 4. Send received data to the client.
                client?.urlProtocol(self, didLoad: data)
            }
            
            // 5. Notify request has been finished.
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // 6. Notify received error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
}
