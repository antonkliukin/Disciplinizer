//
//  CacheMotivationalItemsGateway.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 05.10.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

class CacheMotivationalItemsGateway: MotivationalItemsGatewayProtocol {
    let apiMotivationalItemsGateway: ApiMotivationalItemsGatewayProtocol
    let localPersistenceMotivationalItemsGateway: MotivationalItemsLocalPersistenceGatewayProtocol
    
    init(apiMotivationalItemsGateway: ApiMotivationalItemsGatewayProtocol,
         localPersistenceMotivationalItemsGateway: MotivationalItemsLocalPersistenceGatewayProtocol) {
        self.apiMotivationalItemsGateway = apiMotivationalItemsGateway
        self.localPersistenceMotivationalItemsGateway = localPersistenceMotivationalItemsGateway
    }
    
    func getAll(completionHandler: @escaping (Result<[MotivationalItemConfig], Error>) -> Void) {
        apiMotivationalItemsGateway.getAll { (result) in
            switch result {
            case .success(let items):
                self.localPersistenceMotivationalItemsGateway.save(motivationalItems: items, completionHandler: { _ in })
                completionHandler(result)
            case .failure:
                assertionFailure()
            }
        }
    }
    
    func save(motivationalItems: [MotivationalItemConfig], completionHandler: @escaping (Result<Void, Error>) -> Void) {
        apiMotivationalItemsGateway.save(motivationalItems: motivationalItems) { (result) in
            switch result {
            case .success:
                self.localPersistenceMotivationalItemsGateway.save(motivationalItems: motivationalItems, completionHandler: { _ in })
            case .failure:
                assertionFailure()
            }
        }
    }
}
