//
//  apiManagerTest.swift
//  CheetaTests
//
//  Created by Mahabaleshwar on 24/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import XCTest
@testable import Cheeta

class NetworkManagerTest: XCBaseTestCase {
    
    
    override func setUp() {
        super.setUp()
        MockURLProtocol.delay = .milliseconds(20)
    }
    
    override func tearDown() {
        super.tearDown()
        MockURLProtocol.delay = .milliseconds(0)
    }
    
    func testAPIManagerResponseIsSuccessAndHasValidData() {
        
        let jsonData = try! XCTUnwrap(JSONManager.getJSONData(fileName: "MockResponse"))
        
        MockURLProtocol.mockResponseHandler = { request in
            let successResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (successResponse, jsonData)
        }
        let expectation = XCTestExpectation(description: "api manager should return success and return MockReponse")
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: nil)
        let task = apiManager.sendRequest(request: musicSearchRequest, responseType: MockReponse.self) { (response) in
            switch response {
            case .success( _):
                XCTAssert(true)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: task.originalRequest!.timeoutInterval)
    }
    
    
    func testAPIManagerResponseIsFailedAndReturnsError() {
        
        MockURLProtocol.mockResponseHandler = { request in
            let failureResponse = HTTPURLResponse(url: APIConfig.config.baseURL, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (failureResponse, nil)
        }
        let expectation = XCTestExpectation(description: "api manager should return error and execute fail block")
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: nil)
        let task = apiManager.sendRequest(request: musicSearchRequest, responseType: MockReponse.self) { (response) in
            switch response {
            case .success( _):
                 XCTFail("should not come to success block")
            case .failure( _):
                XCTAssertTrue(true)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: task.originalRequest!.timeoutInterval)
    }
    
    func testAPIManagerShouldReturnErrorWhenResponseHasErrorData() {
        
        MockURLProtocol.mockResponseHandler = { request in
            let failureResponse = HTTPURLResponse(url: APIConfig.config.baseURL, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (failureResponse, Data([0,1,0, 1]))
        }
        let expectation = XCTestExpectation(description: "api manager should return error and execute fail block")
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: nil)
        let task = apiManager.sendRequest(request: musicSearchRequest, responseType: MockReponse.self) { (response) in
            switch response {
            case .success( _):
                 XCTFail("should not come to success block")
            case .failure( _):
                XCTAssertTrue(true)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: task.originalRequest!.timeoutInterval)
    }
    
    func testAPIManagerURLRequestInitialization() {
        let queryItems = ["term": "hamsa", "limit": "50"]
        let headers = ["Content-Type": "application/json", "Accept": "application/json"]
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: queryItems)
        musicSearchRequest.payload = MockReponse(firstName: "hello", lastName: "hegde", country: "india")
        musicSearchRequest.headers = headers
        let urlRequest = apiManager.getURLRequest(request: musicSearchRequest)
       // let expectedURLString = APIConfig.config.baseURL.absoluteString + MusicEnpoints.search.relativePath + "?term=hamsa&limit=50"
        //let url = URL(string: expectedURLString)!
//        XCTAssertEqual(urlRequest.url, url)
        let httpHeaders = try! XCTUnwrap(urlRequest.allHTTPHeaderFields)
        XCTAssertTrue(httpHeaders.contains(where: {headers[$0.key] != nil}))
        XCTAssertTrue(urlRequest.httpMethod == musicSearchRequest.method.rawValue)
        XCTAssertNotNil(urlRequest.httpBody)
        XCTAssertEqual(urlRequest.httpBody, try musicSearchRequest.payload?.toJSONData(), "Payload not equal")
        
        
    }
    
    func testAPIManagerURLRequestInitializationWhenNoEndpoint() {
        let queryItems = ["term": "hamsa", "limit": "50"]
        let headers = ["Content-Type": "application/json", "Accept": "application/json"]
        let musicSearchRequest = APIRequest(endPoint: "", method: .get, queryParams: queryItems)
        musicSearchRequest.payload = MockReponse(firstName: "hello", lastName: "hegde", country: "india")
        musicSearchRequest.headers = headers
        let urlRequest = apiManager.getURLRequest(request: musicSearchRequest)
       // let expectedURLString = APIConfig.config.baseURL.absoluteString + "" + "?term=hamsa&limit=50"
     //   let encoded = expectedURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //let url = URL(string: encoded!)!
//        XCTAssertEqual(urlRequest.url, url)
        let httpHeaders = try! XCTUnwrap(urlRequest.allHTTPHeaderFields)
        XCTAssertTrue(httpHeaders.contains(where: {headers[$0.key] != nil}))
        XCTAssertTrue(urlRequest.httpMethod == musicSearchRequest.method.rawValue)
        XCTAssertNotNil(urlRequest.httpBody)
        XCTAssertEqual(urlRequest.httpBody, try musicSearchRequest.payload?.toJSONData(), "Payload not equal")
        
    }
    
    func testAPIRequestCancel() {
        
        let expectation = XCTestExpectation(description: "api request should cancel and throw cancelled error code")
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: nil)
        let task = apiManager.sendRequest(request: musicSearchRequest, responseType: MockReponse.self) { (response) in
            switch response {
            case .success( _):
                 XCTFail("should not come to success block")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, NSURLErrorCancelled)
            }
            expectation.fulfill()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            task.cancel()
        }
        wait(for: [expectation], timeout: task.originalRequest!.timeoutInterval)
    }
    
    func testAPIManagerShouldReturnErrorWhenRequestIsInCorrect() {
        
        MockURLProtocol.mockResponseHandler = { request in
            throw HTTPStatusCode.badRequest
        }
        let expectation = XCTestExpectation(description: "urlsession data task should return error when api request is incorrect like HTTP method wrong or query params missed")
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: nil)
        let task = apiManager.sendRequest(request: musicSearchRequest, responseType: MockReponse.self) { (response) in
            switch response {
            case .success( _):
                 XCTFail("should not come to success block")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, HTTPStatusCode.badRequest.rawValue)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: task.originalRequest!.timeoutInterval)
    }
    
    func testAPIManagerShouldReturnDataWhenRequestIsCorrect() {
        
        MockURLProtocol.mockResponseHandler = { request in
            let jsonData = JSONManager.getJSONData(fileName: "MockResponse")!
            let successResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (successResponse, jsonData)
        }
        let expectation = XCTestExpectation(description: "urlsession data task should return correct data when api request is correct and api manager should parse response successfully, retun right model")
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: nil)
        let task = apiManager.sendRequest(request: musicSearchRequest, responseType: MockReponse.self) { (response) in
            switch response {
            case .success(let response):
                let expectedResponse = MockReponse(firstName: "John", lastName: "Doe", country: "United Kingdom")
                XCTAssertEqual(expectedResponse, response, "mock response not equal")
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, HTTPStatusCode.badRequest.rawValue)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: task.originalRequest!.timeoutInterval)
    }
    
    
    func testAPIManagerShouldPostDataWhenRequestPayloadIsCorrect() {
        
        let payload = JSONManager.getJSONData(fileName: "MockResponse")!
        MockURLProtocol.mockResponseHandler = { request in
            guard request.httpMethod == HTTPMethod.post.rawValue else {
                throw HTTPStatusCode.methodNotAllowed
            }
            guard request.httpBody == payload else {
                throw ServiceError.payloadMissing
            }
            let jsonData = JSONManager.getJSONData(fileName: "MusicRequestSearchResponse")!
            let successResponse = HTTPURLResponse(url: request.url!, statusCode: 201, httpVersion: nil, headerFields: nil)!
            return (successResponse, jsonData)
        }
        let expectation = XCTestExpectation(description: "urlsession data task should post correct data when payload is passed in api request and api manager should return corresponding response successfully")
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .post, payload:payload,queryParams: nil)
        apiManager.sendRequest(request: musicSearchRequest, responseType: MusicSearchResultContainer.self) { (response) in
            switch response {
            case .success( _):
                XCTAssertTrue(true)
            case .failure(let error as NSError):
                XCTAssertFalse(false, "\(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60.0)
    }
    
    func testAPIManagerSholdReturnErrorWhenRequestHttpMethodIsWrong() {
        
        let payload = JSONManager.getJSONData(fileName: "MockResponse")!
        MockURLProtocol.mockResponseHandler = { request in
            guard request.httpMethod == HTTPMethod.post.rawValue else {
                throw HTTPStatusCode.methodNotAllowed
            }
            guard request.httpBody == payload else {
                throw ServiceError.payloadMissing
            }
            let jsonData = JSONManager.getJSONData(fileName: "MusicRequestSearchResponse")!
            let successResponse = HTTPURLResponse(url: request.url!, statusCode: 201, httpVersion: nil, headerFields: nil)!
            return (successResponse, jsonData)
        }
        let expectation = XCTestExpectation(description: "urlsession data task should return error when HTTP methos is wrong in api request and api manager should throw corresponding error")
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, payload:payload,queryParams: nil)
        apiManager.sendRequest(request: musicSearchRequest, responseType: MusicSearchResultContainer.self) { (response) in
            switch response {
            case .success( _):
                XCTAssertTrue(false)
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, HTTPStatusCode.methodNotAllowed.rawValue)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60.0)
    }
    
    func testAPIManagerSholdReturnErrorWhenRequestPostPayloadIsMissing() {
        
        let payload = JSONManager.getJSONData(fileName: "MockResponse")!
        MockURLProtocol.mockResponseHandler = { request in
            guard request.httpMethod == HTTPMethod.post.rawValue else {
                throw HTTPStatusCode.methodNotAllowed
            }
            guard request.httpBody == payload else {
                throw ServiceError.payloadMissing
            }
            let jsonData = JSONManager.getJSONData(fileName: "MusicRequestSearchResponse")!
            let successResponse = HTTPURLResponse(url: request.url!, statusCode: 201, httpVersion: nil, headerFields: nil)!
            return (successResponse, jsonData)
        }
        let expectation = XCTestExpectation(description: "urlsession data task should throw error when payload is missing in api request and api manager should return corresponding error response")
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .post, payload: nil,queryParams: nil)
        apiManager.sendRequest(request: musicSearchRequest, responseType: MusicSearchResultContainer.self) { (response) in
            switch response {
            case .success( _):
                XCTAssertTrue(false)
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, ServiceError.payloadMissing.rawValue)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60.0)
    }
    
    func testAPIManagerShouldReturnErrorWhenRequestHeaderMissing() {
        
        MockURLProtocol.mockResponseHandler = { request in
            guard let allHTTPHeaderFields = request.allHTTPHeaderFields,
                let _ = allHTTPHeaderFields["Authorization"] else {
                throw HTTPStatusCode.unauthorized
            }
            let jsonData = JSONManager.getJSONData(fileName: "MusicRequestSearchResponse")!
            let successResponse = HTTPURLResponse(url: request.url!, statusCode: 201, httpVersion: nil, headerFields: nil)!
            return (successResponse, jsonData)
        }
        let expectation = XCTestExpectation(description: "urlsession data task should post correct data when payload is passed in api request and api manager should return corresponding response successfully")
        let musicSearchRequest = APIRequest(endPoint: MusicEnpoints.search, method: .post, payload: nil,queryParams: nil)
        apiManager.sendRequest(request: musicSearchRequest, responseType: MusicSearchResultContainer.self) { (response) in
            switch response {
            case .success( _):
                XCTAssertTrue(false)
            case .failure(let error as NSError):
                XCTAssertEqual(error.code, HTTPStatusCode.unauthorized.rawValue)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60.0)
    }
    
    func testAPIManagerSharedInstance() {
        
        let session = URLSession.init(configuration: .default, delegate: nil, delegateQueue: .main)
        XCTAssertEqual(APIManager.shared.session.configuration, session.configuration)
        XCTAssertNil(APIManager.shared.session.delegate)
        XCTAssertEqual(APIManager.shared.session.delegateQueue, session.delegateQueue)
    }
    
}
