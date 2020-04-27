//
//  MotivationSelectionConfigurator.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol TimeSelectionConfiguratorProtocol {
    func configure(timeSelectionViewController: TimeSelectionViewController)
}

class TimeSelectionConfigurator: TimeSelectionConfiguratorProtocol {
    
    func configure(timeSelectionViewController: TimeSelectionViewController) {
        let challengeParametersGateway = ChallengeParametersPersistenceGateway()
        let durationParameterUseCase = DurationParameterUseCase(challengesParametersGateway: challengeParametersGateway)

        let presenter = TimeSelectionPresenter(view: timeSelectionViewController,
                                               durationParameterUseCase: durationParameterUseCase)

        timeSelectionViewController.presenter = presenter
    }
}
