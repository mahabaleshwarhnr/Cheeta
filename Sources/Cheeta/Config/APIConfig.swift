//
//  File.swift
//  
//
//  Created by Mahabaleshwar on 12/04/20.
//

import Foundation

public final class APIConfig {
    
    private var url: URL!
    var baseURL: URL {
        guard let value = url else {
            fatalError("register your API baseURL. base url should be ending with front slash")
        }
        return value
    }
    
    private init() {}
    
    public static let `default`: APIConfig = APIConfig()
    
    public func register(baseURL: URL) {
        url = baseURL
    }
}
