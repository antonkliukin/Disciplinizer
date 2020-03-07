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
    var getLastChallengeUseCase: DisplayLastChallengeUseCaseProtocol?

    func viewDidAppear() {
        checkIfLocked()
        showGuideIfNeeded()
    }

    required init(view: PageNavigationViewProtocol,
                  getLastChallengeUseCase: DisplayLastChallengeUseCaseProtocol) {
        self.view = view
        self.getLastChallengeUseCase = getLastChallengeUseCase
    }

    private func checkIfLocked() {
        AppLockManager.shared.getCurrentState { (state) in
            switch state {
            case .locked:
//                let losingVC = Controller.createLosing(withFailedChallenge: lastFailedChallenge ?? mockedChallange)
//                self.view?.router?.present(losingVC, animated: true, forcePresent: true, completion: nil)
                return
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
