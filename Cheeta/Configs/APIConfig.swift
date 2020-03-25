//
//  APIConfig.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 06/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import Foundation

protocol EnvironmentConfigurable {
    var baseURL: URL { get }
}

final class APIConfig: EnvironmentConfigurable {
    
    enum Target: Int {
        case run
        case test
    }
    
    var currentTarget: Target {
        let info = Bundle(for: type(of: self)).infoDictionary
        guard let target = info?["TargetName"] as? Int else { fatalError("Please set TargetName in info.plist") }
        return Target(rawValue: target)!
    }
    
    lazy private var rootURL: String = {
        let info = Bundle.main.infoDictionary
        guard let rootURL = info?["ROOT_URL"] as? String else { fatalError("Please set ROOT_URL in info.plist") }
        return rootURL
    }()
    
    var baseURL: URL {
        return URL(string: rootURL)!
    }
    
    private init() {}
    
    static let config: APIConfig = APIConfig()
}
