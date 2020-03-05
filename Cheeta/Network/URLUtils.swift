//
//  URLUtils.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 06/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol APIEndPoint {
     var relativePath: String { get }
}

extension String: APIEndPoint {
    var relativePath: String {
        return self
    }
}

typealias CompletionHandler<SucessResponse, ErrorResponse: Error> = (_ result: Result<SucessResponse, ErrorResponse>) -> Void

protocol URLBuilder {
    var baseURL: URL { get }
    var endPoint: String { get }
    var queryParams: [String: String]? { get }
    func getURL() -> URL
}

extension URLBuilder {
        
    func getURL() -> URL {
        let url = URL(string: self.endPoint, relativeTo: baseURL)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = self.queryParams?.map(URLQueryItem.init)
        return components.url!
    }
}
