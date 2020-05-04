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
        view?.showMotivationItems(items)
    }
        
    func didTapBuyButton(onItemWithIndex index: Int) {
        let item = items[index]
        
        PurchasesManager.shared.makePurchase(price: item.price) { (purchaseResult) in
            switch purchaseResult {
            case .success(let state):
                switch state {
                case .purchasing:
                    let loading = Controller.loading()
                    self.view?.router?.present(loading)
                case .purchased:
                    self.view?.router?.dismiss()
                                        
                    self.finishPurchasing(forItem: item)
                default:
                    assertionFailure()
                }
            case .failure:
                assertionFailure()
                return
            }
        }
    }
    
    private func finishPurchasing(forItem item: MotivationalItem) {
        self.motivationParameterUseCase.addPaid(motivationalItem: item) { (result) in
            let alertModel = AlertModel(title: Strings.alertTitleSuccess(),
                                        message: Strings.alertMessageSuccess(),
                                        positiveActionTitle: Strings.alertActionBack(),
                                        positiveAction: {
                                            self.view?.router?.pop(animated: true, toRoot: true)
            })
            
            let alertVC = Controller.alert(model: alertModel)
            
            self.view?.router?.present(alertVC)
        }
    }
}
