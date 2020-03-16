//
//  MotivationSelectionConfigurator.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol MotivationSelectionConfiguratorProtocol {
    func configure(motivationSelectionViewController: MotivatonSelectionViewController)
}

class MotivationSelectionConfigurator: MotivationSelectionConfiguratorProtocol {

    func configure(motivationSelectionViewController: MotivatonSelectionViewController) {
        let challengeParametersGateway = ChallengeParametersPersistenceGateway()
        let motivationalItemParameterUseCase = ItemParameterUseCase(challengesParametersGateway: challengeParametersGateway)

        let presenter = MotivatoinSelectionPresenter(view: motivationSelectionViewController,
                                                     motivationalItemUseCase: motivationalItemParameterUseCase)

        motivationSelectionViewController.presenter = presenter
    }
}
