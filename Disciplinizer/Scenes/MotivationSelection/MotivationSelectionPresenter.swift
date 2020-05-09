//
//  MotivationSelectionPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol MotivationSelectionPresenterProtocol {
    func viewDidLoad()
    func didSelectIndex(_ index: Int)
    func didTapSetModeButton()
}

class MotivatoinSelectionPresenter: MotivationSelectionPresenterProtocol {
    weak var view: MotivationSelectionViewProtocol?
    private let motivationalItemUseCase: MotivationParameterUseCaseProtocol
    
    private var selectedMotivationalItem: MotivationalItem?
    private var newlySelectedMotivationalItem: MotivationalItem?
    private let adMotivationalItem: MotivationalItem = .ad
    private var paidMotivationalItem: MotivationalItem = .noPaidItem

    init(view: MotivationSelectionViewProtocol,
         motivationalItemUseCase: MotivationParameterUseCaseProtocol) {
        self.view = view
        self.motivationalItemUseCase = motivationalItemUseCase
    }
    
    func viewDidLoad() {
        configureViewForSelectedMotivationalItem()
    }
    
    func didSelectIndex(_ index: Int) {
        let isPaidSelected = index == 0
        
        checkIfPaidAvailable { (result) in
            if let paidItem = try? result.get(), isPaidSelected {
                self.newlySelectedMotivationalItem = paidItem
                self.paidMotivationalItem = paidItem
            } else if isPaidSelected {
                self.newlySelectedMotivationalItem = .noPaidItem
            } else {
                self.newlySelectedMotivationalItem = self.adMotivationalItem
            }
            
            if let item = self.newlySelectedMotivationalItem {
                if item == .noPaidItem {
                    self.changeSetModeState(isAbleToSet: false, andTitle: Strings.motivationItemSetButtonAbleToSet())
                } else {
                    let title = self.newlySelectedMotivationalItem != self.selectedMotivationalItem ? Strings.motivationItemSetButtonAbleToSet() : Strings.motivationItemSetButtonUnableToSet()
                    self.changeSetModeState(isAbleToSet: self.newlySelectedMotivationalItem != self.selectedMotivationalItem, andTitle: title)
                }
                
                self.configureMotivationalView(withItem: item)
            }
        }
    }
    
    func didTapSetModeButton() {
        guard let newlySelectedMotivationalItem = newlySelectedMotivationalItem else {
            assertionFailure()
            return
        }

        guard newlySelectedMotivationalItem != .noPaidItem, selectedMotivationalItem != newlySelectedMotivationalItem else {
            return
        }
        
        motivationalItemUseCase.select(motivationalItem: newlySelectedMotivationalItem) { (selectionResult) in
            switch selectionResult {
            case .success:
                self.view?.router?.pop()
            case .failure:
                assertionFailure()
                return
            }
        }
    }
    
    private func configureViewForSelectedMotivationalItem() {
        motivationalItemUseCase.getSelectedMotivationalItem(completionHandler: { (result) in
            if let salectedMotivationalItem = try? result.get() {
                self.newlySelectedMotivationalItem = salectedMotivationalItem
                self.selectedMotivationalItem = salectedMotivationalItem
                
                self.configureMotivationalView(withItem: salectedMotivationalItem)
                
                let isSelectedItemPaid = salectedMotivationalItem != self.adMotivationalItem
                if isSelectedItemPaid {
                    self.paidMotivationalItem = salectedMotivationalItem
                    self.view?.selectIndex(0)
                } else {
                    self.view?.selectIndex(1)
                }
                
                self.changeSetModeState(isAbleToSet: false, andTitle: Strings.motivationItemSetButtonUnableToSet())
            } else {
                self.selectedMotivationalItem = self.paidMotivationalItem
                self.configureMotivationalView(withItem: self.paidMotivationalItem)
            }
        })
    }
    
    private func checkIfPaidAvailable(completionHandler: @escaping (Result<MotivationalItem?, Error>) -> Void) {
        motivationalItemUseCase.getPaid(completionHandler: completionHandler)
    }
        
    func configureMotivationalView(withItem item: MotivationalItem) {
        view?.configureMotivationView(title: item.title,
                                      itemImage: item.image,
                                      descriptionTitle: item.descriptionTitle,
                                      description: item.description,
                                      info: item.info,
                                      actionButtonTitle: item.actionTitle,
                                      actionButtonAction: {
                                        self.view?.router?.push(Controller.createCatStore())
        })
    }
    
    private func changeSetModeState(isAbleToSet: Bool, andTitle title: String) {
        view?.changeSetButtonState(isResponsive: isAbleToSet)
        view?.changeSetButtonTitle(title: title)
    }
}
