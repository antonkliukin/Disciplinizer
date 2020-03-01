//
//  PageNavigationPresenter.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 17.10.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import Foundation

protocol PageNavigationPresenterProtocol {
    func viewDidAppear()
}

final class PageNavigationPresenter: PageNavigationPresenterProtocol {
    weak var view: PageNavigationViewProtocol?
    var challengeRepo: ChallengeStorageProtocol?

    func viewDidAppear() {
        checkIfLocked()
        showGuideIfNeeded()
    }

    required init(view: PageNavigationViewProtocol, challengeRepository: ChallengeStorageProtocol) {
        self.view = view
        self.challengeRepo = challengeRepository
    }

    private func checkIfLocked() {
        AppLockManager.shared.getCurrentState { (state) in
            switch state {
            case .locked:
                let lastFailedChallenge = try? self.challengeRepo?.getLastFailed().get()
                let mockedChallange = Challenge(id: "0",
                                                startDate: Date(),
                                                finishDate: Date(),
                                                duration: 0,
                                                isSuccess: false,
                                                isPaid: true,
                                                betId: BetType.oneDollar.id)

                let losingVC = Controller.createLosing(withFailedChallenge: lastFailedChallenge ?? mockedChallange)
                self.view?.router?.present(losingVC, animated: true, forcePresent: true, completion: nil)

            case .unlocked:
                return
            }
        }
    }

    private func showGuideIfNeeded() {
        if !KeychainService.getGuideState() {
            view?.router?.present(Controller.guide())
        }
    }
}
