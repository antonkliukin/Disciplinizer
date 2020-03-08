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

        let addChallengeUseCase = AddChallengeUseCase(challengesGateway: coreDataChallengesGateway)

        let presenter = CreateChallengePresenter(view: createChallengeViewController,
                                                 addChallengeUseCase: addChallengeUseCase)

        createChallengeViewController.presenter = presenter
    }
}
