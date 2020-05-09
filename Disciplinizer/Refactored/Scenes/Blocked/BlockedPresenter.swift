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

    init(view: BlockedViewProtocol,
         failedChallenge: Challenge,
         purchasesManager: PurchasesManager) {
        self.view = view
        self.challenge = failedChallenge
        self.purchasesManager = purchasesManager
    }

    func viewDidLoad() {
        if challenge.motivationalItem == .ad {
            view?.configureLoseTitle(Strings.loseAdTitle())
            view?.configureLoseDescription(Strings.loseAdDescription())
            view?.setMainButtonTitle(Strings.loseAdMainButton())
            view?.setSecondaryButtonTitle(Strings.loseAdSecondaryButton())
            view?.setImage(R.image.timer()!)
        } else {
            view?.configureLoseTitle(Strings.loseCatTitle())
            view?.configureLoseDescription(Strings.loseCatDescription())
            view?.setMainButtonTitle(Strings.loseCatMainButton())
            view?.setSecondaryButtonTitle(Strings.loseCatSecondaryButton())
            view?.setImage(R.image.crying_cat()!)
        }
    }
    
    func didTapMainButton() {
        if challenge.motivationalItem == .ad {
            view?.router?.present(Controller.createAdVC())
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
}
