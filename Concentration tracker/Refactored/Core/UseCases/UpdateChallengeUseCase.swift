//
//  UpdateChallengeUseCase.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 07.03.2020.
//  Copyright © 2020 FutureCompanyName. All rights reserved.
//

typealias UpdateChallengeUseCaseCompletionHandler = (_ challenges: Result<Challenge, Error>) -> Void

protocol UpdateChallengeUseCaseProtocol {
    func update(challenge: Challenge, completionHandler: @escaping UpdateChallengeUseCaseCompletionHandler)
}

class UpdateChallengeUseCase: UpdateChallengeUseCaseProtocol {
    let challengesGateway: ChallengesGatewayProtocol

    init(challengesGateway: ChallengesGatewayProtocol) {
        self.challengesGateway = challengesGateway
    }

    // MARK: - AddChallengeUseCase

    func update(challenge: Challenge, completionHandler: @escaping (Result<Challenge, Error>) -> Void) {
        challengesGateway.update(challenge: challenge, completionHandler: completionHandler)
    }
}
