//
//  MotivationalItemsPersistenceGateway.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 04.10.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol MotivationalItemsLocalPersistenceGatewayProtocol: MotivationalItemsGatewayProtocol {
    //func update(challenge: Challenge)
}

class MotivationalItemsCoreDataGateway: MotivationalItemsLocalPersistenceGatewayProtocol {
    let viewContext: NSManagedObjectContextProtocol

    init(viewContext: NSManagedObjectContextProtocol) {
        self.viewContext = viewContext
    }

    func getAll(completionHandler: @escaping (Result<[MotivationalItemConfig], Error>) -> Void) {
        if let coreDataMotivationalItems = try? viewContext.allEntities(withType: CDMotivationalItem.self) {
            let motivationalItems = coreDataMotivationalItems.map { $0.motivationalItem }
            completionHandler(.success(motivationalItems))
        } else {
            completionHandler(.failure(CoreError(message: "Failed retrieving motivational items from the data base")))
        }
    }
    
    func save(motivationalItems: [MotivationalItemConfig], completionHandler: @escaping (Result<Void, Error>) -> Void) {
        for item in motivationalItems {
            guard let coreDataMotivationalItem = viewContext.addEntity(withType: CDMotivationalItem.self) else {
                completionHandler(.failure(CoreError(message: "Failed adding the item to the data base")))
                return
            }

            coreDataMotivationalItem.pupulate(with: item)

            do {
                try viewContext.save()
                completionHandler(.success)
            } catch {
                viewContext.delete(coreDataMotivationalItem)
                completionHandler(.failure(CoreError(message: "Failed saving the context")))
            }
        }
    }
}
