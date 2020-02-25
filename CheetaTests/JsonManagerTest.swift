//
//  JsonManagerTest.swift
//  CheetaTests
//
//  Created by Mahabaleshwar on 07/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import XCTest
@testable import Cheeta

class JsonManagerTest: XCTestCase {

    func testJsonManagerInitializedOrNot() {
        let error = ServiceError.unknownError
        let data = Data([0,1,0,1])
        let response = HTTPURLResponse(url: APIConfig.config.baseURL, statusCode: 200, httpVersion: "1.0", headerFields: nil)
        let jsonManager = JSONManager(data: data, response: response, error: error)
        XCTAssertEqual(jsonManager.data, data)
        XCTAssertEqual(jsonManager.response, response)
        XCTAssertEqual(jsonManager.error?.localizedDescription, error.localizedDescription)
    }
    
    
    func testParseMethodThrowsErrorIfResponseHasHTTPError() {
        
        let response = HTTPURLResponse(url: APIConfig.config.baseURL, statusCode: 400, httpVersion: "1.0", headerFields: nil)
        let jsonManager = JSONManager(data: nil, response: response, error: nil)
        XCTAssertThrowsError(try jsonManager.parse(MockReponse.self))
        XCTAssertThrowsError(try jsonManager.parse(MockReponse.self), "Exception thrown") { (error) in
            let httpError = error as? HTTPStatusCode
            XCTAssertNotNil(httpError)
            XCTAssertEqual(httpError!, HTTPStatusCode.badRequest)
        }
    }
    
    func testParseMethodThrowsErrorIfResponseHasError() {
        
        let error = ServiceError.unknownError
        let jsonManager = JSONManager(data: nil, response: nil, error: error)
        XCTAssertThrowsError(try jsonManager.parse(MockReponse.self), "Exception thrown") { (error) in
            let unknownError = error as? ServiceError
            XCTAssertNotNil(unknownError)
            XCTAssertEqual(unknownError!, ServiceError.unknownError)
        }
    }
    
    
    func testParseMethodIfNoErrorAndSuccessResponseButNoData() {
        
        let response = HTTPURLResponse(url: APIConfig.config.baseURL, statusCode: 200, httpVersion: "1.0", headerFields: nil)
        let jsonManager = JSONManager(data: nil, response: response, error: nil)
        XCTAssertThrowsError(try jsonManager.parse(MockReponse.self), "Exception thrown") { (error) in
            let noDataError = error as? ServiceError
            XCTAssertNotNil(noDataError)
            XCTAssertEqual(noDataError!, ServiceError.noData)
        }
    }
    
    func testParseMethodIfNoErrorAndSuccessResponseHasValidData() {
        
        let jsonString = """
        {
            "first_name": "John",
            "last_name": "Doe",
            "country": "United Kingdom"
        }
        """
        let jsonData = jsonString.data(using: .utf8)!
        let response = HTTPURLResponse(url: APIConfig.config.baseURL, statusCode: 200, httpVersion: "1.0", headerFields: nil)
        let jsonManager = JSONManager(data: jsonData, response: response, error: nil)
        XCTAssertNoThrow(try jsonManager.parse(MockReponse.self), "error thrown")
    }
    
    func testParseMethodFetchJsonFileFromSourceAndReturnsValidData() {
        
        let jsonData = JSONManager.getJSONData(fileName: "MockResponse")
        XCTAssertNotNil(jsonData)
        let response = HTTPURLResponse(url: APIConfig.config.baseURL, statusCode: 200, httpVersion: "1.0", headerFields: nil)
        let jsonManager = JSONManager(data: jsonData, response: response, error: nil)
        XCTAssertNoThrow(try jsonManager.parse(MockReponse.self), "error thrown")

    }
    
    func testEnocdePayloadReturnsValidData() {
        
        let mockPayload = MockReponse(firstName: "Mabu", lastName: "hegde", country: "India")
        XCTAssertNoThrow(try JSONManager.encode(mockPayload))

    }

}
