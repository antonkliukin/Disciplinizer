//
//  DisplayLastChallenge.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 07.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

typealias DisplayLastChallengeUseCaseCompletionHandler = (_ challenges: Result<Challenge?, Error>) -> Void

protocol DisplayLastChallengeUseCaseProtocol {
    func displayLastChallenge(completionHandler: @escaping DisplayLastChallengeUseCaseCompletionHandler)
}

class DisplayLastChallengeUseCase: DisplayLastChallengeUseCaseProtocol {
    let challengesGateway: ChallengesGatewayProtocol

    init(challengesGateway: ChallengesGatewayProtocol) {
        self.challengesGateway = challengesGateway
    }

    // MARK: - DisplayChallengesUseCase

    func displayLastChallenge(completionHandler: @escaping (Result<Challenge?, Error>) -> Void) {
        challengesGateway.getLastChallenge { (result) in
            // Do any additional processing & after that call the completion handler
            completionHandler(result)
        }
    }
}
