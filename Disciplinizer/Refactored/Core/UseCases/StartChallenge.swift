//
//  AddChallenge.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 07.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

typealias StartChallengeUseCaseCompletionHandler = (_ challenge: Result<Challenge, Error>) -> Void

protocol StartChallengeUseCaseProtocol {
    func start(challenge: Challenge, completionHandler: @escaping StartChallengeUseCaseCompletionHandler)
}

class StartChallengeUseCase: StartChallengeUseCaseProtocol {
    let challengeManager: ChallengeManager

    init(challengeManager: ChallengeManager) {
        self.challengeManager = challengeManager
    }

    func start(challenge: Challenge, completionHandler: @escaping (Result<Challenge, Error>) -> Void) {
        challengeManager.start(challenge) { (finishedChallenge) in
            completionHandler(finishedChallenge)
        }
    }
}
