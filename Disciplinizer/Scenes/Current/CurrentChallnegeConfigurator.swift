//
//  CurrentChallnegeConfigurator.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 07.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol CurrentChallengeConfiguratorProtocol {
    func configure(currentChallengeViewController: CurrentChallengeViewController)
}

class CurrentChallengeConfigurator: CurrentChallengeConfiguratorProtocol {
    let challenge: Challenge

    init(challenge: Challenge) {
        self.challenge = challenge
    }

    func configure(currentChallengeViewController: CurrentChallengeViewController) {
        let viewContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let coreDataChallengesGateway = CoreDataChallengesGateway(viewContext: viewContext)

        let startChallengeUseCase = StartChallengeUseCase()
        let finishChallengeUseCase = FinishChallengeUseCase(challengesGateway: coreDataChallengesGateway)

        let songsGateway = SongsGateway()
        let changePlaybackStateUseCase = ChangePlaybackStateUseCase(songsGateway: songsGateway)
        let changeMutedPlaybackStateUseCase = ChangeMutedPlaybackStateUseCase(songsGateway: songsGateway)
        
        let challengeParametersGateway = ChallengeParametersPersistenceGateway()
        let motivationParameterUseCase = MotivationParameterUseCase(challengesParametersGateway: challengeParametersGateway)
        
        let presenter = CurrentChallengePresenter(view: currentChallengeViewController,
                                                  challenge: challenge,
                                                  startChallengeUseCase: startChallengeUseCase,
                                                  finishChallengeUseCase: finishChallengeUseCase,
                                                  changePlaybackStateUseCase: changePlaybackStateUseCase,
                                                  changeMutedPlaybackStateUseCase: changeMutedPlaybackStateUseCase,
                                                  motivationParameterUseCase: motivationParameterUseCase)
        
        currentChallengeViewController.presenter = presenter
    }
}
