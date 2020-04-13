//
//  MusicListViewModelTest.swift
//  CheetaTests
//
//  Created by Mahabaleshwar on 28/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import XCTest
@testable import Cheeta

class MusicListViewModelTest: XCBaseTestCase {

    private var viewModel: MusicListViewModel!
    
    
    override func setUp() {
        super.setUp()
        viewModel = MusicListViewModel()
        viewModel.networkManager = apiManager
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }

    func testMusicListTestResturnsValidData() {
        let searchTerm = "hello"
        let query = ["term": searchTerm, "limit": "50"]
        let apiRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: query)
        MockURLProtocol.mockResponseHandler = { request in
            guard request.url?.queryDictionary == apiRequest.queryParams else {
                throw ValidationError.queryParamsMissing
            }
            let data = JSONManager.getJSONData(fileName: "MusicRequestSearchResponse")
            let httpResponse = HTTPURLResponse(url: apiRequest.getURL(), statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (httpResponse, data)
        }
        let expectation = XCTestExpectation(description: "Fecth music list should fail")
        viewModel.fetchMusicList(searchTerm: searchTerm) { (response) in
            XCTAssertNotNil(response, "Music List response returns nil \(response as Any)")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testMusicListReturnsNilResponseWhenDataIsNilOrError() {
        let searchTerm = "hello"
        let query = ["term": searchTerm, "limit": "50"]
        let apiRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: query)
        MockURLProtocol.mockResponseHandler = { request in
            guard let url = request.url,  url == apiRequest.getURL() else {
                throw ServiceError.invalidURLRequest
            }
            guard url.queryDictionary == apiRequest.queryParams else {
                throw ValidationError.queryParamsMissing
            }
            
            let httpResponse = HTTPURLResponse(url: apiRequest.getURL(), statusCode: 500, httpVersion: "2.0", headerFields: nil)!
            return (httpResponse, nil)
        }
        
        let expectation = XCTestExpectation(description: "Fecth music list should success")
        viewModel.fetchMusicList(searchTerm: searchTerm) { (response) in
            XCTAssertNil(response, "Music List response not nil")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30.0)
    }
}
