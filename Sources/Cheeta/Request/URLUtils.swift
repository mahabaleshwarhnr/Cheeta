//
//  URLUtils.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 06/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol APIEndPoint {
    var relativePath: String { get }
}

extension String: APIEndPoint {
    public var relativePath: String {
        return self
    }
}

public typealias CompletionHandler<SucessResponse, ErrorResponse: Error> = (_ result: Result<SucessResponse, ErrorResponse>) -> Void

public protocol URLBuilder {
    var baseURL: URL { get }
    var endPoint: String { get }
    var queryParams: [String: String]? { get }
    func getURL() -> URL
}

extension URLBuilder {
        
    public func getURL() -> URL {
        let url: URL!
        if self.endPoint.relativePath.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
            url = URL(string: self.endPoint, relativeTo: baseURL)!
        } else {
            url = baseURL
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = self.queryParams?.map(URLQueryItem.init)
        return components.url!
    }
    
    public var baseURL: URL {
        return APIConfig.config.baseURL
    }
}
