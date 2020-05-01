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
    
    private var savedMotivation: MotivationalItem?
    private var selectedMotivation: MotivationalItem?
    private let adMotivation: MotivationalItem = .ad
    private var paidMotivation: MotivationalItem = .noPaidItem

    init(view: MotivationSelectionViewProtocol,
         motivationalItemUseCase: MotivationParameterUseCaseProtocol) {
        self.view = view
        self.motivationalItemUseCase = motivationalItemUseCase
    }
    
    func viewDidLoad() {
        configureMotivationView()
    }
    
    func didSelectIndex(_ index: Int) {
        let motivation = index == 0 ? paidMotivation : adMotivation
                
        self.selectedMotivation = motivation
        configureViewForMotivation(motivation)
        
        if motivation == .noPaidItem {
            changeSetModeState(isAbleToSet: false, andTitle: Strings.motivationItemSetButtonAbleToSet())
        } else {
            let title = savedMotivation != selectedMotivation ? Strings.motivationItemSetButtonAbleToSet() : Strings.motivationItemSetButtonUnableToSet()
            changeSetModeState(isAbleToSet: savedMotivation != selectedMotivation, andTitle: title)
        }
    }
    
    func didTapSetModeButton() {
        guard let selectedMotivation = selectedMotivation else {
            assertionFailure()
            return
        }

        guard selectedMotivation != .noPaidItem, selectedMotivation != savedMotivation else {
            return
        }
        
        motivationalItemUseCase.select(motivationalItem: selectedMotivation) { (selectionResult) in
            switch selectionResult {
            case .success:
                self.view?.router?.pop()
            case .failure:
                assertionFailure()
                return
            }
        }
    }
    
    private func configureMotivationView() {
        motivationalItemUseCase.getSelectedMotivationalItem(completionHandler: { (result) in
            if let savedMotivation = try? result.get() {
                self.savedMotivation = savedMotivation
                self.selectedMotivation = savedMotivation
                self.configureViewForMotivation(savedMotivation)
                
                if savedMotivation != self.adMotivation {
                    self.paidMotivation = savedMotivation
                    self.view?.selectIndex(0)
                } else {
                    self.view?.selectIndex(1)
                }
                
                self.changeSetModeState(isAbleToSet: false, andTitle: Strings.motivationItemSetButtonUnableToSet())
            } else {
                self.selectedMotivation = self.paidMotivation
                self.configureViewForMotivation(self.paidMotivation)
            }
        })
    }
        
    func configureViewForMotivation(_ item: MotivationalItem) {
        view?.configureMotivationView(title: item.title,
                                      itemImage: item.image,
                                      descriptionTitle: item.descriptionTitle,
                                      description: item.description,
                                      info: item.info,
                                      actionButtonTitle: item.actionTitle,
                                      actionButtonAction: {
                                        print("Go to cat store")
        })
    }
    
    private func changeSetModeState(isAbleToSet: Bool, andTitle title: String) {
        view?.changeSetButtonState(isResponsive: isAbleToSet)
        view?.changeSetButtonTitle(title: title)
    }
}
