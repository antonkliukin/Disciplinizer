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
        static let item = "motivationalItem"
        static let paidItem = "paidMotivationalItem"
        static let time = "time"
    }

    func select(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        userDefaults.set(motivationalItem.rawValue, forKey: Key.item)
    }

    func getCurrentMotivationalItem(completionHandler: @escaping (Result<MotivationalItem, Error>) -> Void) {
        guard let itemId = userDefaults.string(forKey: Key.item), let item = MotivationalItem(rawValue: itemId) else {
            completionHandler(.failure(UserDefaultsError(message: "Item is not saved.")))
            return
        }

        completionHandler(.success(item))
    }

    func select(duration: TimeInterval, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        userDefaults.set(duration, forKey: Key.item)
    }

    func getCurrentDuration(completionHandler: @escaping (Result<TimeInterval, Error>) -> Void) {
        let duration = userDefaults.double(forKey: Key.item)
        
        guard duration > 0 else {
            completionHandler(.failure(UserDefaultsError(message: "Duration is not saved.")))
            return
        }

        completionHandler(.success(duration))
    }

    func addPaid(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        
    }

    func getPaid(completionHandler: @escaping (Result<MotivationalItem, Error>) -> Void) {

    }
}
