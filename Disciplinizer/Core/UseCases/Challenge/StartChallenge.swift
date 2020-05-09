//
//  AddChallenge.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 07.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol StartChallengeUseCaseProtocol {
    func start(challenge: Challenge, completionHandler: @escaping (_ challenge: Result<Challenge, Error>) -> Void)
}

class StartChallengeUseCase: StartChallengeUseCaseProtocol {
    init() {
    }

    func start(challenge: Challenge, completionHandler: @escaping (Result<Challenge, Error>) -> Void) {
    }
}
