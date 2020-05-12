//
//  NewChallengeParametersGatewayProtocol.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol ChallengeParametersGatewayProtocols {
    func save(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void)
    func getMotivationalItem(completionHandler: @escaping (Result<MotivationalItem, Error>) -> Void)
    func save(durationInMinutes: Int, completionHandler: @escaping (Result<Void, Error>) -> Void)
    func getDurationInMinutes(completionHandler: @escaping (Result<Int, Error>) -> Void)
    func savePaid(motivationalItem: MotivationalItem, completionHandler: @escaping (Result<Void, Error>) -> Void)
    func getPaid(completionHandler: @escaping (Result<MotivationalItem?, Error>) -> Void)
    func deletePaid(completionHandler: @escaping (Result<Void, Error>) -> Void)
}
