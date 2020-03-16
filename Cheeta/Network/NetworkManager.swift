//
//  NetworkManager.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 06/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import UIKit

protocol NetworkManagerInitializable {
    static var shared: NetworkManagerInitializable { get }
    var session: URLSessionProtocol { get }
    init(session: URLSessionProtocol)
    @discardableResult func sendRequest<Response: Decodable, Request: RequestConfigurable>(request: Request,responseType: Response.Type, completionHandler: @escaping CompletionHandler<Response, Error>) -> URLSessionDataTaskProtocol
    func getURLRequest(request: RequestConfigurable) -> URLRequest
}

extension NetworkManagerInitializable {
    
    func getURLRequest(request: RequestConfigurable) -> URLRequest {
        
        var urlRequest = URLRequest(url: request.getURL(), cachePolicy: request.cachePolicy, timeoutInterval: request.timeoutInterval)
        urlRequest.httpMethod = request.method.rawValue
        if let headerValue = request.headers {
            for (key, value) in headerValue  {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        if let body = request.payload {
            urlRequest.httpBody = try? body.toJSONData()
        }
        return urlRequest
    }
    
    @discardableResult
    func sendRequest<Response, Request>(request: Request, responseType: Response.Type, completionHandler: @escaping (Result<Response, Error>) -> Void) -> URLSessionDataTaskProtocol where Response : Decodable, Request : RequestConfigurable {
        
        let urlRequest = self.getURLRequest(request: request)
        
        let dataTask = self.session.dataTask(request: urlRequest) {  (data, urlResponse, error) in
            let jsonManager = JSONManager(data: data, response: urlResponse, error: error)
            do {
                let responseModel = try jsonManager.parse(responseType)
                completionHandler(Result.success(responseModel))
            } catch let parseError {
                completionHandler(Result.failure(parseError))
            }
        }
        dataTask.resume()
        return dataTask
    }
}


class APIManager: NSObject, NetworkManagerInitializable {
    
    static var shared: NetworkManagerInitializable {
        return APIManager(session: URLSession(configuration: .default, delegate: nil, delegateQueue: .main))
    }
    
    private(set) var session: URLSessionProtocol
    
    required init(session: URLSessionProtocol) {
        self.session = session
    }
}




