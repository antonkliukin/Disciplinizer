//
//  LosingPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 09.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol BlockedPresenterProtocol {
    func viewDidLoad()
    func didTapMainButton()
    func didTapSecondaryButton()
}

final class BlockedPresenter: BlockedPresenterProtocol {
    private weak var view: BlockedViewProtocol?
    private var challenge: Challenge
    private var purchasesManager: PurchasesManager
    private var motivationalItemParameterUseCase: MotivationParameterUseCaseProtocol

    init(view: BlockedViewProtocol,
         failedChallenge: Challenge,
         purchasesManager: PurchasesManager,
         motivationalItemParameterUseCase: MotivationParameterUseCaseProtocol) {
        self.view = view
        self.challenge = failedChallenge
        self.purchasesManager = purchasesManager
        self.motivationalItemParameterUseCase = motivationalItemParameterUseCase
    }

    func viewDidLoad() {
        if challenge.motivationalItem == .ad {
            view?.configureLoseTitle(Strings.loseAdTitle())
            view?.configureLoseDescription(Strings.loseAdDescription())
            view?.setMainButtonTitle(Strings.loseAdMainButton())
            view?.setImage(R.image.timer()!)
            
            motivationalItemParameterUseCase.getPaid { (result) in
                if (try? result.get()) == nil {
                    self.view?.setSecondaryButtonTitle(Strings.loseAdSecondaryButton())
                }
            }
        } else {
            unlockApp()
            
            view?.configureLoseTitle(Strings.loseCatTitle())
            view?.configureLoseDescription(Strings.loseCatDescription())
            view?.setMainButtonTitle(Strings.loseCatMainButton())
            view?.setSecondaryButtonTitle(Strings.loseCatSecondaryButton())
            view?.setImage(R.image.crying_cat()!)
        }
    }
    
    func didTapMainButton() {
        if challenge.motivationalItem == .ad {
            rootVC.present(Controller.createAdVC(), animated: true, completion: nil)
        } else {
            view?.router?.present(Controller.createCatStore())
        }
    }
    
    func didTapSecondaryButton() {
        if challenge.motivationalItem == .ad {
            view?.router?.present(Controller.createCatStore())
        } else {
            view?.router?.dismiss()
        }
    }
    
    private func unlockApp() {
        AppLockManager.shared.changeStateTo(.unlocked)
        KeychainService.appLockState = .unlocked
    }
}
