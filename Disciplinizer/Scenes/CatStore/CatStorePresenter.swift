//
//  CatStorePresenter.swift
//  Disciplinizer
//
//  Created by Anton on 01.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol CatStorePresenterProtocol {
    func viewDidLoad()
    func didTapBuyButton(onItemWithIndex index: Int)
    func didTapCloseButton()
}

class CatStorePresenter: CatStorePresenterProtocol {
    weak var view: CatStoreViewProtocol?
    private var motivationParameterUseCase: MotivationParameterUseCaseProtocol
    
    private var loadingVC: UIViewController?
        
    private var items: [MotivationalItem] {
        MotivationalItem.allCats
    }
    
    init(view: CatStoreViewProtocol,
         motivationParameterUseCase: MotivationParameterUseCaseProtocol) {
        self.view = view
        self.motivationParameterUseCase = motivationParameterUseCase
    }
        
    func viewDidLoad() {
        view?.set(viewTitle: Strings.catStoreTitle())
        view?.set(description: Strings.catStoreDescription())
        view?.showMotivationItems(items)
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
                    self.loadingVC = loading
                    self.view?.router?.present(loading)
                case .purchased:
                    self.loadingVC?.dismiss(animated: true, completion: {
                        self.finishPurchasing(forItem: item)
                    })
                default:
                    assertionFailure()
                }
            case .failure:
                self.view?.router?.dismissPresenting(animated: true, completion: nil)
            }
        }
    }
    
    private func finishPurchasing(forItem item: MotivationalItem) {
        AppLockManager.shared.changeStateTo(.unlocked)
        KeychainService.appLockState = .unlocked
        
        self.motivationParameterUseCase.addPaid(motivationalItem: item) { (_) in
            
            self.motivationParameterUseCase.select(motivationalItem: item) { (_) in }
            
            let alertModel = AlertModel(title: Strings.alertTitleSuccess(),
                                        message: Strings.alertMessageSuccess(),
                                        positiveActionTitle: Strings.alertActionBack(),
                                        positiveAction: {
                                            if self.view?.isPresented ?? false {
                                                self.view?.router?.dismissPresenting(animated: true, completion: nil)
                                            } else {
                                                self.view?.router?.pop(animated: true, toRoot: true)
                                            }
                                            
            })
            
            let alert = Controller.createAlert(alertModel: alertModel)
            
            self.view?.router?.present(alert)
        }
    }
}
