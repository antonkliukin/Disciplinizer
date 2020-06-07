//
//  BlockedStateConfigurator.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 11.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol LoseConfiguratorProtocol {
    func configure(viewController: LoseViewController)
}

class LoseConfigurator: LoseConfiguratorProtocol {
    let challenge: Challenge

    init(challenge: Challenge) {
        self.challenge = challenge
    }
    
    func configure(viewController: LoseViewController) {
        let purchasesManager = PurchasesManager.shared
        
        let challengeParametersGateway = ChallengeParametersPersistenceGateway()
        let motivationalItemParameterUseCase = MotivationParameterUseCase(challengesParametersGateway: challengeParametersGateway)
        
        let presenter = LosePresenter(view: viewController,
                                      failedChallenge: challenge,
                                      purchasesManager: purchasesManager,
                                      motivationalItemParameterUseCase: motivationalItemParameterUseCase)
        
        viewController.presenter = presenter
    }
}
