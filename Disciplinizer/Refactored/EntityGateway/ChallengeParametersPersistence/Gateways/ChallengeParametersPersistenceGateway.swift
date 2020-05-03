//
//  ChallengeParametersPersistenceGateway.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

class ChallengeParametersPersistenceGateway: ChallengeParametersGatewayProtocols {
    private var userDefaults = UserDefaults.standard

    private enum Key {
        static let purchasedItem = "purchasedItem"
        static let selectedItem = "selectedItem"
        static let selectedTime = "selectedTime"
    }

    func save(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        userDefaults.set(motivationalItem.rawValue, forKey: Key.selectedItem)
        completionHandler(.success)
    }

    func getMotivationalItem(completionHandler: @escaping (Result<MotivationalItem, Error>) -> Void) {
        guard let itemId = userDefaults.string(forKey: Key.selectedItem), let item = MotivationalItem(rawValue: itemId) else {
            completionHandler(.failure(UserDefaultsError(message: "Item is not saved.")))
            return
        }

        completionHandler(.success(item))
    }

    func save(durationInMinutes: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        userDefaults.set(durationInMinutes, forKey: Key.selectedTime)
        completionHandler(.success)
    }

    func getDurationInMinutes(completionHandler: @escaping (Result<Int, Error>) -> Void) {
        let duration = userDefaults.integer(forKey: Key.selectedTime)
        
        guard duration > 0 else {
            completionHandler(.failure(UserDefaultsError(message: "Duration is not saved.")))
            return
        }

        completionHandler(.success(duration))
    }

    func savePaid(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        userDefaults.set(motivationalItem.rawValue, forKey: Key.purchasedItem)
        completionHandler(.success)
    }

    func getPaid(completionHandler: @escaping (Result<MotivationalItem?, Error>) -> Void) {
        guard let itemId = userDefaults.string(forKey: Key.selectedItem) else {
            completionHandler(.failure(UserDefaultsError(message: "Item is not saved.")))
            return
        }
        
        guard let item = MotivationalItem(rawValue: itemId) else {
            completionHandler(.success(nil))
            return
        }

        completionHandler(.success(item))
    }
}
