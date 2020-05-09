//
//  ChallengesGateway.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 29.02.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol ChallengesGatewayProtocol {
    func getAll(completionHandler: @escaping (_ challenges: Result<[Challenge], Error>) -> Void)
    func getLast(completionHandler: @escaping (_ challenge: Result<Challenge?, Error>) -> Void)
    func add(parameters: ChallengeParameters, completionHandler: @escaping (_ challenge: Result<Challenge, Error>) -> Void)
    func update(challenge: Challenge, completionHandler: @escaping (_ challenge: Result<Challenge, Error>) -> Void)
    func delete(challenge: Challenge, completionHandler: @escaping (_ challenge: Result<Void, Error>) -> Void)
    func deleteAll(completionHandler: @escaping (_ challenge: Result<Void, Error>) -> Void)
}
