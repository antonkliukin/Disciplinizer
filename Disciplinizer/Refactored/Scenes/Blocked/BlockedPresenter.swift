//
//  LosingPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 09.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol BlockedPresenterProtocol {
    func didTapPurchase()
    func viewDidLoad()
}

final class BlockedPresenter: BlockedPresenterProtocol {
    private weak var view: BlockedViewProtocol?
    private var challenge: Challenge
    private var purchasesManager: PurchasesManagerProtocol

    init(view: BlockedViewProtocol, failedChallenge: Challenge, purchasesManager: PurchasesManagerProtocol) {
        self.view = view
        self.challenge = failedChallenge
        self.purchasesManager = purchasesManager
    }

    func viewDidLoad() {
        view?.configureLoseMessage(Strings.purchaseLoseMessage())
        view?.setButtonTitle(Strings.purchaseButtonTitle())
    }

    func didTapPurchase() {
        guard NetworkState.isConnected else {
            // TODO: Show alert
            assertionFailure("Internet connection is needed")
            return
        }

        if challenge.isPaid {
            guard let betId = challenge.betId,
                  let bet = BetType.allCases.first(where: { $0.id == betId }) else {
                    AppLockManager.shared.changeStateTo(.unlocked)
                    view?.router?.dismiss()
                    return
            }

            purchasesManager.makePurchase(forBet: bet) { [weak self] purchaseResult in
                switch purchaseResult {
                case .success:
                    AppLockManager.shared.changeStateTo(.unlocked)
                    self?.view?.router?.dismiss()
                default:
                    self?.view?.showError("Purchase error occured")
                }
            }
        } else {
            // TODO: Add free mode
            AppLockManager.shared.changeStateTo(.unlocked)
            view?.router?.dismiss()
        }
    }
}
