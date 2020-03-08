//
//  ChallengesGateway.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 29.02.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

typealias GetAllCompletionHandler = (_ challenges: Result<[Challenge], Error>) -> Void
typealias GetLastCompletionHandler = (_ challenge: Result<Challenge?, Error>) -> Void
typealias AddChallengeCompletionHandler = (_ challenge: Result<Challenge, Error>) -> Void
typealias UpdateChallengeCompletionHandler = (_ challenge: Result<Challenge, Error>) -> Void
typealias DeleteChallengeCompletionHandler = (_ challenge: Result<Void, Error>) -> Void

protocol ChallengesGatewayProtocol {
    func getAll(completionHandler: @escaping GetAllCompletionHandler)
    func getLast(completionHandler: @escaping GetLastCompletionHandler)
    func add(parameters: ChallengeParameters, completionHandler: @escaping AddChallengeCompletionHandler)
    func update(challenge: Challenge, completionHandler: @escaping UpdateChallengeCompletionHandler)
    func delete(challenge: Challenge, completionHandler: @escaping DeleteChallengeCompletionHandler)
    func deleteAll(completionHandler: @escaping DeleteChallengeCompletionHandler)
}
