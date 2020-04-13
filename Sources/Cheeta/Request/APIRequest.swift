//
//  APIRequest.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 07/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import Foundation

public protocol URLRequestInitializable {
    var method: HTTPMethod { get }
    var headers: [String: String]? { get set }
    var payload: Encodable? { get }
    var cachePolicy: URLRequest.CachePolicy { get set }
    var timeoutInterval: TimeInterval { get set }
    var queryParams: [String : String]? { get }
    var endPoint: String { get }
    
}

public protocol APIRequestInitializable: URLRequestInitializable {
    
    init(endPoint: APIEndPoint, method: HTTPMethod, payload: Encodable?, queryParams: [String: String]?)
}

public typealias RequestConfigurable = APIRequestInitializable & URLBuilder


public struct APIRequest: RequestConfigurable {
    public var timeoutInterval: TimeInterval = 60.0
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    public var headers: [String : String]?
    
    private(set) public var payload: Encodable?
    private(set) public var method: HTTPMethod
    private(set) public var endPoint: String
    private(set) public var queryParams: [String : String]?
    
    public init(endPoint: APIEndPoint,
                  method: HTTPMethod,
                  payload: Encodable? = nil,
                  queryParams: [String : String]?) {
        self.endPoint = endPoint.relativePath
        self.method = method
        self.payload = payload
        self.queryParams = queryParams
    }
}


