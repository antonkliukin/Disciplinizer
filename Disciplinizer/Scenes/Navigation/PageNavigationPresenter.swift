//
//  PageNavigationPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 17.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol PageNavigationPresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
}

final class PageNavigationPresenter: PageNavigationPresenterProtocol {
    weak var view: PageNavigationViewProtocol?
    
    private var getLastChallengeUseCase: DisplayLastChallengeUseCaseProtocol?
    private let motivationParameterUseCase: MotivationParameterUseCaseProtocol
    
    func viewDidLoad() {
        //
    }
    
    func viewWillAppear() {
        //
    }
        
    func viewDidAppear() {
        checkIfFirstLaunch()
    }

    required init(view: PageNavigationViewProtocol,
                  getLastChallengeUseCase: DisplayLastChallengeUseCaseProtocol,
                  motivationParameterUseCase: MotivationParameterUseCaseProtocol) {
        self.view = view
        self.getLastChallengeUseCase = getLastChallengeUseCase
        self.motivationParameterUseCase = motivationParameterUseCase
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
    
    var test = true
    
    private func checkIfFirstLaunch() {
//        if test {
//            test = false
//            self.view?.router?.present(Controller.guideChat())
//        }
        
        return
            
//        AppLockManager.shared.checkIfFirstLaunch { (isFirstLaunch) in
//            // TODO: Delete test conditions
//            if true/*isFirstLaunch*/, true/*KeychainService.isFirstLaunch*/ {
//                KeychainService.isFirstLaunch = false
//                KeychainService.appLockState = .unlocked
//                AppLockManager.shared.changeStateTo(.unlocked)
//                self.addPaidItem()
//                
//                // self.view?.router?.present(Controller.guide())
//            }
//        }
    }
    
    private func addPaidItem() {
        let paid = MotivationalItem.level1
        motivationParameterUseCase.addPaid(motivationalItem: paid) { (_) in }
    }
}
