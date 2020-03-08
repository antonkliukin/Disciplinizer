//
//  DeleteChallenge.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 29.02.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

typealias DeleteChallengeUseCaseCompletionHandler = (_ challenges: Result<Void, Error>) -> Void
typealias DeleteAllChallengeUseCaseCompletionHandler = (_ challenges: Result<Void, Error>) -> Void

struct DeleteChallengeUseCaseNotifications {
    // Notification sent when a challnege is deleted having the challenge set to the notification object
    static let didDeleteChallenge = Notification.Name("didDeleteChallengeNotification")
}

protocol DeleteChallengeUseCaseProtocol {
    func delete(challenge: Challenge, completionHandler: @escaping DeleteChallengeUseCaseCompletionHandler)
    func deleteAll(completionHandler: @escaping DeleteAllChallengeUseCaseCompletionHandler)
}

class DeleteChallengeUseCase: DeleteChallengeUseCaseProtocol {

    let challengeGateway: ChallengesGatewayProtocol

    init(challengeGateway: ChallengesGatewayProtocol) {
        self.challengeGateway = challengeGateway
    }

    // MARK: - DeleteChallengeUseCase

    func delete(challenge: Challenge, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        challengeGateway.delete(challenge: challenge) { (result) in
            // Do any additional processing & after that call the completion handler
            // In this case we will broadcast a notification
            switch result {
            case .success:
                NotificationCenter.default.post(name: DeleteChallengeUseCaseNotifications.didDeleteChallenge, object: challenge)
                completionHandler(result)
            case .failure:
                completionHandler(result)
            }
        }
    }

    func deleteAll(completionHandler: @escaping DeleteAllChallengeUseCaseCompletionHandler) {
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
