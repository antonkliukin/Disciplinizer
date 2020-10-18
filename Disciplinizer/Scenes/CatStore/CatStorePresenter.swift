//
//  CatStorePresenter.swift
//  Disciplinizer
//
//  Created by Anton on 01.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol CatStorePresenterProtocol {
    func viewDidLoad()
    func didTapBuyButton(onItemWithIndex index: Int)
    func didTapCloseButton()
}

class CatStorePresenter: CatStorePresenterProtocol {
    weak var view: CatStoreViewProtocol?
    private var motivationParameterUseCase: MotivationParameterUseCaseProtocol
            
    private var items: [MotivationalItem] {
        MotivationalItem.allCats
    }
    
    init(view: CatStoreViewProtocol,
         motivationParameterUseCase: MotivationParameterUseCaseProtocol) {
        self.view = view
        self.motivationParameterUseCase = motivationParameterUseCase
    }
        
    func viewDidLoad() {
        if PurchasesManager.shared.didGetPrices {
            setupStoreView()
        } else {
            PurchasesManager.shared.getAvailiablePrices { (prices) in
                DispatchQueue.main.async {
                    if prices.isEmpty {
                        let alertModel = AlertModel(title: Strings.catStoreAlertFailedTitle(),
                                                    message: Strings.catStoreAlertFailedMessage(),
                                                    positiveActionTitle: Strings.catStoreAlertFailedAction())
                        
                        let alertVC = Controller.createAlert(alertModel: alertModel, didTapPositive: {
                            if self.view?.isPresented ?? false {
                                self.view?.router?.dismiss()
                            } else {
                                self.view?.router?.pop(animated: true, toRoot: true)
                            }
                        })
                        self.view?.router?.present(alertVC)
                    } else {
                        self.setupStoreView()
                    }
                }
            }
        }
    }
    
    func didTapCloseButton() {
        view?.router?.dismiss()
    }
        
    func didTapBuyButton(onItemWithIndex index: Int) {
        let item = items[index]
        
        PurchasesManager.shared.makePurchase(price: item.price) { (purchaseResult) in
            switch purchaseResult {
            case .success(let state):
                switch state {
                case .purchasing:
                    let loading = Controller.loading()
                    rootVC.present(loading, animated: true, completion: nil)
                case .purchased:
                    rootVC.dismiss(animated: true) {
                       self.finishPurchasing(forItem: item)
                    }
                default:
                    assertionFailure()
                }
            case .failure:
                rootVC.dismiss(animated: true)
            }
        }
    }
    
    private func setupStoreView() {
        view?.set(viewTitle: Strings.catStoreTitle())
        view?.set(description: Strings.catStoreDescription())
        view?.showMotivationItems(items)
    }
    
    private func finishPurchasing(forItem item: MotivationalItem) {
        AppLockManager.shared.changeStateTo(.unlocked)
        KeychainService.appLockState = .unlocked
        
        self.motivationParameterUseCase.addPaid(motivationalItem: item) { (_) in
            
            self.motivationParameterUseCase.select(motivationalItem: item) { (_) in }
            
            let alertModel = AlertModel(title: Strings.alertTitleSuccess(),
                                        message: Strings.alertMessageSuccess(),
                                        positiveActionTitle: Strings.alertActionBack())
            
            let alert = Controller.createAlert(alertModel: alertModel, didTapPositive: {
                if self.view?.isPresented ?? false {
                    self.view?.router?.dismissToParent(snapshot: true, completion: nil)
                } else {
                    self.view?.router?.pop(animated: true, toRoot: true)
                }
            })
            
            self.view?.router?.present(alert)
        }
    }
}
