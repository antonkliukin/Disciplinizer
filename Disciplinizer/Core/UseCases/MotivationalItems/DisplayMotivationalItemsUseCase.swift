//
//  DisplayAllItems.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 16.09.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol DisplayMotivationalItemsUseCaseProtocol {
    func displayItems(completionHandler: @escaping (_ challenges: Result<[MotivationalItemConfig], Error>) -> Void)
}

class DisplayMotivationalItemsUseCase: DisplayMotivationalItemsUseCaseProtocol {
    let itemsGateway: MotivationalItemsGatewayProtocol

    init(itemsGateway: MotivationalItemsGatewayProtocol) {
        self.itemsGateway = itemsGateway
    }

    func displayItems(completionHandler: @escaping (Result<[MotivationalItemConfig], Error>) -> Void) {
        itemsGateway.getAll { (result) in
            completionHandler(result)
        }
    }
}
