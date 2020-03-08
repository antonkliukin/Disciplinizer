//
//  PageNavigationPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 17.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
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
        showGuideIfFirstLaunch()
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
                self.getLastChallengeUseCase?.displayLastChallenge(completionHandler: { (lastChallengeGettingResult) in
                    switch lastChallengeGettingResult {
                    case .success(let lastChallenge):
                        guard let challenge = lastChallenge, !challenge.isSuccess else {
                            assertionFailure()
                            return
                        }

                        let losingVC = Controller.createLosing(withFailedChallenge: challenge)
                        self.view?.router?.present(losingVC, animated: true, forcePresent: true, completion: nil)
                    case .failure:
                        assertionFailure()
                        return
                    }

                })
                return
            case .unlocked:
                return
            }
        }
    }

    private func showGuideIfFirstLaunch() {
        if !KeychainService.getGuideState() {
            view?.router?.present(Controller.guide())
        }
    }
}
