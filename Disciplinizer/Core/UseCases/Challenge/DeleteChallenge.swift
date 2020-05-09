//
//  DeleteChallenge.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 29.02.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol DeleteChallengeUseCaseProtocol {
    func delete(challenge: Challenge, completionHandler: @escaping (_ challenges: Result<Void, Error>) -> Void)
    func deleteAll(completionHandler: @escaping (_ challenges: Result<Void, Error>) -> Void)
}

class DeleteChallengeUseCase: DeleteChallengeUseCaseProtocol {

    let challengeGateway: ChallengesGatewayProtocol

    init(challengeGateway: ChallengesGatewayProtocol) {
        self.challengeGateway = challengeGateway
    }

    func delete(challenge: Challenge, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        challengeGateway.delete(challenge: challenge) { (result) in
            completionHandler(result)
        }
    }

    func deleteAll(completionHandler: @escaping (_ challenges: Result<Void, Error>) -> Void) {
        challengeGateway.deleteAll { (result) in
            switch result {
            case .success:
                completionHandler(result)
            case .failure:
                completionHandler(result)
            }
        }
    }
}
