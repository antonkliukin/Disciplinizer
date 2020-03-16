//
//  NewChallengeParametersGatewayProtocol.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol ChallengeParametersGatewayProtocols {
    func select(motivationalItem: MotivationalItem, completionHandler: @escaping (_ challenges: Result<Void, Error>) -> Void)
    func getCurrentMotivationalItem(completionHandler: @escaping (_ challenge: Result<MotivationalItem, Error>) -> Void)
    func select(duration: TimeInterval, completionHandler: @escaping (_ challenges: Result<Void, Error>) -> Void)
    func getCurrentDuration(completionHandler: @escaping (_ challenge: Result<TimeInterval, Error>) -> Void)
    func addPaid(motivationalItem: MotivationalItem, completionHandler: @escaping (_ challenge: Result<Void, Error>) -> Void)
    func getPaid(completionHandler: @escaping (_ challenge: Result<MotivationalItem, Error>) -> Void)
}
