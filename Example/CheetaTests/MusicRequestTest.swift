//
//  MusicRequestTest.swift
//  CheetaTests
//
//  Created by Mahabaleshwar on 24/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import XCTest
@testable import Cheeta

class MusicRequestTest: XCTestCase {

    func testMusicSearchRequestResponseMappping() {
        
        let jsonData = JSONManager.getJSONData(fileName: "MusicRequestSearchResponse")
        XCTAssertNotNil(jsonData)
        let response = HTTPURLResponse(url: APIConfig.config.baseURL, statusCode: 200, httpVersion: "1.0", headerFields: nil)
        let jsonManager = JSONManager(data: jsonData, response: response, error: nil)
        do {
           let _ = try jsonManager.parse(MusicSearchResultContainer.self)
            XCTAssertTrue(true)
        } catch let error as NSError  {
            XCTFail("test music request response mapping failed:\(error.userInfo.description)")
        }
    }
}
