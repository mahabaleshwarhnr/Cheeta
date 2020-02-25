//
//  ResponseSerializer.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 07/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import UIKit


protocol BaseReponse {
    var data: Data? { get }
    var response: URLResponse? { get }
    var error: Error? { get }
    init(data: Data?, response: URLResponse?, error: Error?)
}

protocol DataResponseDeSerializer: BaseReponse {
    
    func parse<Response: Decodable>(_ type: Response.Type) throws -> Response
}

protocol DataResponseSerializer: BaseReponse {
    static func encode<Payload: Encodable>(_ type: Payload) throws -> Data
}

class JSONManager: DataResponseDeSerializer, DataResponseSerializer  {
    
    
    private(set) var data: Data?
    private(set) var response: URLResponse?
    private(set) var error: Error?
    
    private let jsonDecoder  = JSONDecoder()
    private let jsonEncoder  = JSONEncoder()
    
    required init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.response = response
        self.error = error
        
    }
    
    func parse<Response>(_ type: Response.Type) throws -> Response where Response : Decodable {
        
        if let error = error {
            throw error
        }
        
        if let httpResponse = response as? HTTPURLResponse, !httpResponse.isSuccess {
            throw httpResponse.httpStatusCode ?? ServiceError.unknownError
        }
        guard let resonseData = data else {
            throw ServiceError.noData
        }
        return try jsonDecoder.decode(type, from: resonseData)
    }
    
    static func encode<Payload>(_ type: Payload) throws -> Data where Payload : Encodable {
        return try type.toJSONData()
    }
    
    static func getJSONData(fileName: String) -> Data?  {
        let resourcePath = Bundle(for: JSONManager.self).path(forResource: fileName, ofType: "json") ?? ""
        return NSData(contentsOfFile: resourcePath) as Data?
    }
}

extension Encodable {
    func toJSONData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

enum ParseError: Error {
    case responseTypeNotFound
}

enum ServiceError: Error {
    case unknownError
    case noData
}
