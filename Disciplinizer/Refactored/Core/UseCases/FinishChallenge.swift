//
//  FinishChallenge.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 07.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol FinishChallengeUseCaseProtocol {
    func finish(challenge: Challenge, completionHandler: @escaping (_ challenge: Result<Challenge, Error>) -> Void)
}

class FinishChallengeUseCase: FinishChallengeUseCaseProtocol {
    let challengesGateway: ChallengesGatewayProtocol

    init(challengesGateway: ChallengesGatewayProtocol) {
        self.challengesGateway = challengesGateway
    }

    func finish(challenge: Challenge, completionHandler: @escaping (Result<Challenge, Error>) -> Void) {
        challengesGateway.update(challenge: challenge, completionHandler: completionHandler)
    }
}
