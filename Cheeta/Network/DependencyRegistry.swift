//
//  DependencyRegistry.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 24/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import Foundation


class DependencyRegistry {
    
    private static var registry: NetworkManagerInitializable.Type!
    
    static func getNetWorkManager() -> NetworkManagerInitializable {
        if let value = registry {
            return value.shared
        } else {
            let target = APIConfig.config.currentTarget
            switch target {
            case .run:
                return APIManager.shared
            case .test:
                return MockNetworkManager.shared
            }
        }
    }
    
    static func setRegistry(_ registry: NetworkManagerInitializable.Type) {
        self.registry = registry
    }
}
