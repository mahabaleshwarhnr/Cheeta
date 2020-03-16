//
//  MusicListViewModelTest.swift
//  CheetaTests
//
//  Created by Mahabaleshwar on 28/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import XCTest
@testable import Cheeta

class MusicListViewModelTest: XCTestCase {

    private var viewModel: MusicListViewModel!
    
    override func setUp() {
        self.viewModel = MusicListViewModel()
    }

    func testMusicListTestResturnsValidData() {
        let data = JSONManager.getJSONData(fileName: "MusicRequestSearchResponse")
        viewModel.networkManager = getMockedNetworkManager(data: data, error: nil)
        viewModel.fetchMusicList(searchTerm: "hello") { (response) in
            XCTAssertNotNil(response, "Music List response returns nil")
            
        }
    }
    
    func testMusicListTestResturnsNilResponseWhenDataIsNilOrError() {
        viewModel.networkManager = getMockedNetworkManager(data: nil, error: HTTPStatusCode.noContent)
        viewModel.fetchMusicList(searchTerm: "hello") { (response) in
            XCTAssertNil(response, "Music List response not nil")
        }
    }
    
    
    private func getMockedNetworkManager(data: Data?, error: Error?) -> NetworkManagerInitializable {
        let session = MockedURLSession()
        session.data = data
        let networkManager = APIManager(session: session)
        return networkManager
    }
}
