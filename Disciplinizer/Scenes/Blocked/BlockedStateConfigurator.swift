//
//  BlockedStateConfigurator.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 11.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol BlockedStateConfiguratorProtocol {
    func configure(blockedViewController: BlockedViewController)
}

class BlockedStateConfigurator: BlockedStateConfiguratorProtocol {
    let challenge: Challenge

    init(challenge: Challenge) {
        self.challenge = challenge
    }

    func configure(blockedViewController: BlockedViewController) {
        let purchasesManager = PurchasesManager.shared
        
        let challengeParametersGateway = ChallengeParametersPersistenceGateway()
        let motivationalItemParameterUseCase = MotivationParameterUseCase(challengesParametersGateway: challengeParametersGateway)
        
        let presenter = BlockedPresenter(view: blockedViewController,
                                         failedChallenge: challenge,
                                         purchasesManager: purchasesManager,
                                         motivationalItemParameterUseCase: motivationalItemParameterUseCase)

        blockedViewController.presenter = presenter
    }
}
