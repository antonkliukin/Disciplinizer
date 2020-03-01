//
//  AddBook.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 29.02.2020.
//  Copyright © 2020 FutureCompanyName. All rights reserved.
//

import Foundation

typealias AddChallengeUseCaseCompletionHandler = (_ books: Result<Challenge, Error>) -> Void

protocol AddChallengeUseCaseProtocol {
    func add(parameters: AddChallengeParameters, completionHandler: @escaping AddChallengeUseCaseCompletionHandler)
}

// This class is used across all layers - Core, UI and Network
// It's not violating any dependency rules.
// However it might make sense for each layer do define it's own input parameters so it can be used independently of the other layers.
struct AddChallengeParameters {
    var startDate: Date?
    var finishDate: Date?
    var duration: TimeInterval
    var isSuccess: Bool
    var isPaid: Bool
    var betId: String?
}

class AddChallengeUseCase: AddChallengeUseCaseProtocol {
    let challengesGateway: ChallengesGatewayProtocol

    init(challengesGateway: ChallengesGatewayProtocol) {
        self.challengesGateway = challengesGateway
    }

    // MARK: - AddBookUseCase

    func add(parameters: AddChallengeParameters, completionHandler: @escaping (Result<Challenge, Error>) -> Void) {
        challengesGateway.add(parameters: parameters) { (result) in
            // Do any additional processing & after that call the completion handler
            completionHandler(result)
        }
    }

}
