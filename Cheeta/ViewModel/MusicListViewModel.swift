//
//  MusicListViewModel.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 24/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import UIKit

class MusicListViewModel: NSObject {
    
    var networkManager  = DependencyRegistry.getNetWorkManager()
}

extension MusicListViewModel {
    
    func fetchMusicList(searchTerm: String, completion: ((_ data: MusicSearchResultContainer?) -> Void)? = nil) {
        
        let query = ["term": searchTerm, "limit": "50"]
        let apiRequest = APIRequest(endPoint: MusicEnpoints.search, method: .get, queryParams: query)
        networkManager.sendRequest(request: apiRequest, responseType: MusicSearchResultContainer.self) { (response) in
            switch response {
            case .success(let result):
                completion?(result)
            case .failure(let error as NSError):
                print("failed: \(error.userInfo)")
                completion?(nil)
            }
        }
    }
}
