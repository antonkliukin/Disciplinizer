//
//  PageNavigationConfigurator.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 07.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol PageNavigationConfiguratorProtocol {
    func configure(pageNavigationViewController: PageNavigationViewController)
}

class PageNavigationConfigurator: PageNavigationConfiguratorProtocol {

    func configure(pageNavigationViewController: PageNavigationViewController) {
        let viewContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let coreDataChallengesGateway = CoreDataChallengesGateway(viewContext: viewContext)

        let challengeParameterGateway = ChallengeParametersPersistenceGateway()
        let motivationParameterUseCase = MotivationParameterUseCase(challengesParametersGateway: challengeParameterGateway)

        let presenter = PageNavigationPresenter(view: pageNavigationViewController,
                                                motivationParameterUseCase: motivationParameterUseCase)

        pageNavigationViewController.presenter = presenter
    }
}
