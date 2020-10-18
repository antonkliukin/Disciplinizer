//
//  ModeSelectoinConfigurator.swift
//  Disciplinizer
//
//  Created by Anton on 10.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol ModeSelectoinConfiguratorProtocol {
    func configure(modeSelectionViewController: ModeSelectionViewController)
}

final class ModeSelectoinConfigurator: ModeSelectoinConfiguratorProtocol {
    weak var routerDelegate: RouterDelegateProtocol?
    
    init(routerDelegate: RouterDelegateProtocol?) {
        self.routerDelegate = routerDelegate
    }
    
    func configure(modeSelectionViewController: ModeSelectionViewController) {
        let challengeParametersGateway = ChallengeParametersPersistenceGateway()
        let motivationalItemParameterUseCase = MotivationParameterUseCase(challengesParametersGateway: challengeParametersGateway)

        let presenter = ModeSelectionPresenter(view: modeSelectionViewController,
                                               routerDelegate: routerDelegate,
                                               motivationalItemParameterUseCase: motivationalItemParameterUseCase)
        modeSelectionViewController.presenter = presenter
    }
}
