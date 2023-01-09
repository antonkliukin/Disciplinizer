//
//  LosingPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 09.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol LosePresenterProtocol {
    func viewDidLoad()
    func didTapMainButton()
    func didTapSecondaryButton()
}

final class LosePresenter: LosePresenterProtocol {
    private weak var view: LoseViewProtocol?
    private var challenge: Challenge
    private var purchasesManager: PurchasesManager
    private var motivationalItemParameterUseCase: MotivationParameterUseCaseProtocol

    init(view: LoseViewProtocol,
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
            view?.configureLoseTitle(R.string.localizable.loseAdTitle())
            view?.configureLoseDescription(R.string.localizable.loseAdDescription())
            view?.setMainButtonTitle(R.string.localizable.loseAdMainButton())
            view?.setImage(R.image.timer()!)
            
            motivationalItemParameterUseCase.getPaid { (result) in
                if (try? result.get()) == nil {
                    self.view?.setSecondaryButtonTitle(R.string.localizable.loseAdSecondaryButton())
                }
            }
        } else {
            unlockApp()
            
            view?.configureLoseTitle(R.string.localizable.loseCatTitle())
            view?.configureLoseDescription(R.string.localizable.loseCatDescription())
            view?.setMainButtonTitle(R.string.localizable.loseCatMainButton())
            view?.setSecondaryButtonTitle(R.string.localizable.loseCatSecondaryButton())
            view?.setImage(R.image.crying_cat()!)
        }
    }
        
    func didTapMainButton() {
        if challenge.motivationalItem == .ad {
            rootVC.present(Controller.createAdVC(adDismissDelegate: self), animated: true, completion: nil)
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

extension LosePresenter: AdDismissDelegateProtocol {
    func didDismiss() {
        view?.router?.dismissToParent(snapshot: true, completion: nil)
    }
}
