//
//  AddChallenge.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 29.02.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol CreateChallengeUseCaseProtocol {
    func createWith(parameters: ChallengeParameters, completionHandler: @escaping (_ challenge: Result<Challenge, Error>) -> Void)
}

// This class is used across all layers - Core, UI and Network
// It's not violating any dependency rules.
// However it might make sense for each layer do define it's own input parameters so it can be used independently of the other layers.
struct ChallengeParameters {
    var startDate: Date?
    var finishDate: Date?
    var durationInMinutes: Int
    var isSuccess: Bool
    var isPaid: Bool
    var betId: String?
}

class CreateChallengeUseCase: CreateChallengeUseCaseProtocol {
    let challengesGateway: ChallengesGatewayProtocol

    init(challengesGateway: ChallengesGatewayProtocol) {
        self.challengesGateway = challengesGateway
    }

    func createWith(parameters: ChallengeParameters, completionHandler: @escaping (Result<Challenge, Error>) -> Void) {
        challengesGateway.add(parameters: parameters) { (result) in
            // Do any additional processing & after that call the completion handler
            completionHandler(result)
        }
    }
}
