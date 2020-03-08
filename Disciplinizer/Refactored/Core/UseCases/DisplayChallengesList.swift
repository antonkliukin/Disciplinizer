//
//  DisplayChallengesList.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 29.02.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

typealias DisplayChallengesUseCaseCompletionHandler = (_ challenges: Result<[Challenge], Error>) -> Void

protocol DisplayChallengesUseCaseProtocol {
    func displayChallenges(completionHandler: @escaping DisplayChallengesUseCaseCompletionHandler)
}

class DisplayChallengesListUseCase: DisplayChallengesUseCaseProtocol {
    let challengesGateway: ChallengesGatewayProtocol

    init(challengesGateway: ChallengesGatewayProtocol) {
        self.challengesGateway = challengesGateway
    }

    func displayChallenges(completionHandler: @escaping (Result<[Challenge], Error>) -> Void) {
        challengesGateway.getAll { (result) in
            completionHandler(result)
        }
    }
}
