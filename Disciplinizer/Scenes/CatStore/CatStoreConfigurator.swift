//
//  CatStoreConfigurator.swift
//  Disciplinizer
//
//  Created by Anton on 01.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol CatStoreConfiguratorProtocol {
    func configure(catStoreViewController: CatStoreViewController)
}

class CatStoreConfigurator: CatStoreConfiguratorProtocol {

    func configure(catStoreViewController: CatStoreViewController) {
        let challengesParameterGateway = ChallengeParametersPersistenceGateway()
        let motivationParameterUseCase = MotivationParameterUseCase(challengesParametersGateway: challengesParameterGateway)
        
        let presenter = CatStorePresenter(view: catStoreViewController,
                                          motivationParameterUseCase: motivationParameterUseCase)

        catStoreViewController.presenter = presenter
    }
}
