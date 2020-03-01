//
//  HistoryConfigurator.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 29.02.2020.
//  Copyright © 2020 FutureCompanyName. All rights reserved.
//

import Foundation

protocol HistoryConfiguratorProtocol {
    func configure(historyViewController: HistoryViewController)
}

class HistoryConfigurator: HistoryConfiguratorProtocol {

    func configure(historyViewController: HistoryViewController) {
        let viewContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let coreDataChallengesGateway = CoreDataChallengesGateway(viewContext: viewContext)

        let displayChallengesUseCase = DisplayChallengesListUseCase(challengesGateway: coreDataChallengesGateway)
        let deleteChallengeUseCase = DeleteChallengeUseCase(challengeGateway: coreDataChallengesGateway)

        let saveChallengeUseCase = AddChallengeUseCase(challengesGateway: coreDataChallengesGateway)

        for _ in 1...30 {
            let challengeParameters = AddChallengeParameters(startDate: Date(),
                                                             finishDate: nil,
                                                             duration: 2000,
                                                             isSuccess: false,
                                                             isPaid: false,
                                                             betId: nil)
            saveChallengeUseCase.add(parameters: challengeParameters) { (result) in
                switch result {
                case .success(let challenge):
                    print(challenge)
                default:
                    print("Def")
                }
            }
        }

        let presenter = HistoryPresenter(view: historyViewController,
                                         displayChallengesUseCase: displayChallengesUseCase,
                                         deleteChallengesUseCase: deleteChallengeUseCase)

        historyViewController.presenter = presenter
    }
}
