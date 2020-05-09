//
//  CreateChallengeConfigurator.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 05.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol CreateChallengeConfiguratorProtocol {
    func configure(createChallengeViewController: CreateChallengeViewController)
}

class CreateChallengeConfigurator: CreateChallengeConfiguratorProtocol {

    func configure(createChallengeViewController: CreateChallengeViewController) {
        let viewContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let coreDataChallengesGateway = CoreDataChallengesGateway(viewContext: viewContext)

        let createChallengeUseCase = CreateChallengeUseCase(challengesGateway: coreDataChallengesGateway)

        let challengeParametersGateway = ChallengeParametersPersistenceGateway()
        let motivationalItemParameterUseCase = MotivationParameterUseCase(challengesParametersGateway: challengeParametersGateway)
        let durationParameterUseCase = DurationParameterUseCase(challengesParametersGateway: challengeParametersGateway)

        let presenter = CreateChallengePresenter(view: createChallengeViewController,
                                                 createChallengeUseCase: createChallengeUseCase,
                                                 motivationalItemUseCase: motivationalItemParameterUseCase,
                                                 durationParameterUseCase: durationParameterUseCase)

        createChallengeViewController.presenter = presenter
    }
}
