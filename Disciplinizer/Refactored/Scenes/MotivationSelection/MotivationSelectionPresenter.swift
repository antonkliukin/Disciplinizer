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
    
    private var selectedMotivation: MotivationalItem?
    private let adMotivation: MotivationalItem = .ad
    private var paidMotivation: MotivationalItem?

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
        
        guard let selectedMotivation = motivation else {
            assertionFailure()
            return
        }
        
        self.selectedMotivation = selectedMotivation
        configureViewForMotivation(selectedMotivation)
    }
    
    func didTapSetModeButton() {
        guard let selectedMotivation = selectedMotivation else {
            assertionFailure()
            return
        }
        
        motivationalItemUseCase.select(motivationalItem: selectedMotivation) { (_) in return }
    }
    
    private func configureMotivationView() {
        motivationalItemUseCase.getSelectedMotivationalItem(completionHandler: { (selectedItemResult) in
            if let selectedMotivation = try? selectedItemResult.get() {
                self.selectedMotivation = selectedMotivation
                self.configureViewForMotivation(selectedMotivation)
            } else {
                self.selectedMotivation = self.adMotivation
                self.configureViewForMotivation(self.adMotivation)
            }
        })
    }
        
    func configureViewForMotivation(_ item: MotivationalItem) {
        let info = getInfoFor(item)
        let actionTitle = getActionTitleFor(item)
                
        view?.configureMotivationView(title: item.title,
                                      itemImage: item.image,
                                      descriptionTitle: item.descriptionTitle,
                                      description: item.description,
                                      info: info,
                                      actionButtonTitle: actionTitle,
                                      actionButtonAction: {
                                        print("Go to cat store")
        })
    }
    
    private func getInfoFor(_ item: MotivationalItem) -> String {
        var info = ""
        let isPaidAvailable = paidMotivation != nil
        let isPaidSelected = item != .ad
        
        if isPaidSelected {
            if isPaidAvailable {
                info = Strings.motivationItemInfoHaveCat()
            } else {
                info = Strings.motivationItemInfoNotCat()
            }
        }

        return info
    }
    
    private func getActionTitleFor(_ item: MotivationalItem) -> String {
        var title = ""
        let isPaidAvailable = paidMotivation != nil
        let isPaidSelected = item != .ad
        
        if isPaidSelected, !isPaidAvailable {
            title = Strings.motivationItemActionTitle()
        }

        return title
    }
}
