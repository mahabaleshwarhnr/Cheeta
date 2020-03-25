//
//  MockUtils.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 07/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import Foundation

struct MockReponse: Codable {
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case country
    }
    
    let firstName, lastName, country: String
}

extension MockReponse: Equatable {
    
}

