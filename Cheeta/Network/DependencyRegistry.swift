//
//  DependencyRegistry.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 24/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import Foundation


class DependencyRegistry {
    
    private static var registry: NetworkManagerInitializable.Type = APIManager.self
    
    static func getNetWorkManager() -> NetworkManagerInitializable {
        //        return registry.shared
        let target = APIConfig.config.currentTarget
        switch target {
        case .run:
            return registry.shared
        case .test:
            return MockNetworkManager.shared
        }
    }
    
    static private func setRegistry(_ registry: NetworkManagerInitializable.Type) {
        self.registry = registry
    }
}
