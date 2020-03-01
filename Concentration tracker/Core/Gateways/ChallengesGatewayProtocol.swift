//
//  ChallengesGateway.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 29.02.2020.
//  Copyright © 2020 FutureCompanyName. All rights reserved.
//

import Foundation

typealias GetChallengesEntityGatewayCompletionHandler = (_ books: Result<[Challenge], Error>) -> Void
typealias AddChallengeEntityGatewayCompletionHandler = (_ books: Result<Challenge, Error>) -> Void
typealias DeleteChallengeEntityGatewayCompletionHandler = (_ books: Result<Void, Error>) -> Void

protocol ChallengesGatewayProtocol {
    func getChallenges(completionHandler: @escaping GetChallengesEntityGatewayCompletionHandler)
    func add(parameters: AddChallengeParameters, completionHandler: @escaping AddChallengeEntityGatewayCompletionHandler)
    func delete(challenge: Challenge,
                completionHandler: @escaping DeleteChallengeEntityGatewayCompletionHandler)
    func deleteAll(completionHandler: @escaping DeleteChallengeEntityGatewayCompletionHandler)
}
