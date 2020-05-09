//
//  ChallengeParametersPersistenceGateway.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

class ChallengeParametersPersistenceGateway: ChallengeParametersGatewayProtocols {

    private enum Key {
        static let purchasedItem = "purchasedItem"
        static let selectedItem = "selectedItem"
        static let selectedTime = "selectedTime"
    }

    func save(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        KeychainService.selectedItem = motivationalItem

        completionHandler(.success)
    }

    func getMotivationalItem(completionHandler: @escaping (Result<MotivationalItem, Error>) -> Void) {
        guard let item = KeychainService.selectedItem else {
            completionHandler(.failure(UserDefaultsError(message: "Item is not saved.")))
            return
        }

        completionHandler(.success(item))
    }

    func save(durationInMinutes: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        KeychainService.selectedTime = durationInMinutes
        completionHandler(.success)
    }

    func getDurationInMinutes(completionHandler: @escaping (Result<Int, Error>) -> Void) {
        let duration = KeychainService.selectedTime
        
        guard duration > 0 else {
            completionHandler(.failure(UserDefaultsError(message: "Duration is not saved.")))
            return
        }

        completionHandler(.success(duration))
    }

    func savePaid(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        KeychainService.purchasedItem = motivationalItem
        completionHandler(.success)
    }

    func getPaid(completionHandler: @escaping (Result<MotivationalItem?, Error>) -> Void) {
        guard let item = KeychainService.purchasedItem else {
            completionHandler(.success(nil))
            return
        }
        
        completionHandler(.success(item))
    }
}
