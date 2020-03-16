//
//  APIRequest.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 07/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import Foundation

protocol URLRequestInitializable {
    var method: HTTPMethod { get }
    var headers: [String: String]? { get set }
    var payload: Encodable? { get }
    var cachePolicy: URLRequest.CachePolicy { get set }
    var timeoutInterval: TimeInterval { get set }
    
}


protocol APIRequestInitializable: URLRequestInitializable {
    

    init(endPoint: APIEndPoint, method: HTTPMethod, payload: Encodable?, queryParams: [String: String]?)
}

typealias RequestConfigurable = APIRequestInitializable & URLBuilder

// TODO:- make it protocol

class APIRequest: RequestConfigurable {
    
    var baseURL: URL {
        return APIConfig.config.baseURL
    }
    
    var timeoutInterval: TimeInterval = 60.0
    var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    var endPoint: String
    var queryParams: [String : String]?
    var method: HTTPMethod
    var headers: [String : String]?
    var payload: Encodable?    
    
    required init(endPoint: APIEndPoint, method: HTTPMethod, payload: Encodable? = nil, queryParams: [String : String]?) {
        self.endPoint = endPoint.relativePath
        self.method = method
        self.payload = payload
        self.queryParams = queryParams
    }
}



