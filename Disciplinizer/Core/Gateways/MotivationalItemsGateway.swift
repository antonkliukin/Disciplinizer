//
//  MotivationalItemsGateway.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 08.09.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol MotivationalItemsGatewayProtocol {
    func getAll(completionHandler: @escaping (_ motivationalItems: Result<[MotivationalItemConfig], Error>) -> Void)
    func save(motivationalItems: [MotivationalItemConfig], completionHandler: @escaping (Result<Void, Error>) -> Void)
}
