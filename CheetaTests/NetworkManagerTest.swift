//
//  NetworkManagerTest.swift
//  CheetaTests
//
//  Created by Mahabaleshwar on 24/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import XCTest
@testable import Cheeta

class NetworkManagerTest: XCTestCase {
    
    private var networkManager: NetworkManagerInitializable! = MockNetworkManager.shared
    
    func testNetworkManagerResponseIsSuccessAndHasValidData() {
        
        let session = MockedURLSession()
        let jsonData = try! XCTUnwrap(JSONManager.getJSONData(fileName: "MockResponse"))
        session.data = jsonData
        networkManager = MockNetworkManager(session: session)
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: nil)
        networkManager.sendRequest(request: musicSearchRequest, responseType: MockReponse.self) { (response) in
            switch response {
            case .success( _):
                XCTAssert(true)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    
    func testNetworkManagerResponseIsFailedAndReturnsError() {
        
        let session = MockedURLSession()
        session.data = nil
        session.httpResponse = HTTPURLResponse(url: APIConfig.config.baseURL, statusCode: 400, httpVersion: nil, headerFields: nil)
        networkManager = MockNetworkManager(session: session)
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: nil)
        networkManager.sendRequest(request: musicSearchRequest, responseType: MockReponse.self) { (response) in
            switch response {
            case .success( _):
                 XCTFail("should not come to success block")
            case .failure( _):
                XCTAssertTrue(true)
               
            }
        }
    }
    
    func testNetworkManagerShouldReturnErrorWhenResponseHasErrorData() {
        
        let session = MockedURLSession()
        session.data = Data([0,1,0, 1])
        session.httpResponse = HTTPURLResponse(url: APIConfig.config.baseURL, statusCode: 400, httpVersion: nil, headerFields: nil)
        networkManager = MockNetworkManager(session: session)
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: nil)
        networkManager.sendRequest(request: musicSearchRequest, responseType: MockReponse.self) { (response) in
            switch response {
            case .success( _):
                 XCTFail("should not come to success block")
            case .failure( _):
                XCTAssertTrue(true)
               
            }
        }
    }
    
    func testNetworkManagerURLRequestInitialization() {
        let queryItems = ["term": "hamsa", "limit": "50"]
        let headers = ["Content-Type": "application/json", "Accept": "application/json"]
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: queryItems)
        musicSearchRequest.payload = MockReponse(firstName: "hello", lastName: "hegde", country: "india")
        musicSearchRequest.headers = headers
        let urlRequest = networkManager.getURLRequest(request: musicSearchRequest)
        let expectedURLString = APIConfig.config.baseURL.absoluteString + MusicEnpoints.search.relativePath + "?term=hamsa&limit=50"
        let url = URL(string: expectedURLString)!
        XCTAssertEqual(urlRequest.url?.path, url.path)
        XCTAssertEqual(urlRequest.url?.query, url.query, "Query not equal")
        let httpHeaders = try! XCTUnwrap(urlRequest.allHTTPHeaderFields)
        XCTAssertTrue(httpHeaders.contains(where: {headers[$0.key] != nil}))
        XCTAssertTrue(urlRequest.httpMethod == musicSearchRequest.method.rawValue)
        XCTAssertNotNil(urlRequest.httpBody)
        XCTAssertEqual(urlRequest.httpBody, try musicSearchRequest.payload?.toJSONData(), "Payload not equal")
        
    }
}
