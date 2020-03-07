//
//  ChallengesGateway.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 29.02.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

typealias GetChallengesEntityGatewayCompletionHandler = (_ challenges: Result<[Challenge], Error>) -> Void
typealias GetLastChallengeEntityGatewayCompletionHandler = (_ challenges: Result<Challenge?, Error>) -> Void
typealias AddChallengeEntityGatewayCompletionHandler = (_ challenge: Result<Challenge, Error>) -> Void
typealias UpdateChallengeEntityGatewayCompletionHandler = (_ challenge: Result<Challenge, Error>) -> Void
typealias DeleteChallengeEntityGatewayCompletionHandler = (_ challenge: Result<Void, Error>) -> Void

protocol ChallengesGatewayProtocol {
    func getChallenges(completionHandler: @escaping GetChallengesEntityGatewayCompletionHandler)
    func getLastChallenge(completionHandler: @escaping GetLastChallengeEntityGatewayCompletionHandler)
    func add(parameters: AddChallengeParameters, completionHandler: @escaping AddChallengeEntityGatewayCompletionHandler)
    func update(challenge: Challenge, completionHandler: @escaping UpdateChallengeEntityGatewayCompletionHandler)
    func delete(challenge: Challenge,
                completionHandler: @escaping DeleteChallengeEntityGatewayCompletionHandler)
    func deleteAll(completionHandler: @escaping DeleteChallengeEntityGatewayCompletionHandler)
}
