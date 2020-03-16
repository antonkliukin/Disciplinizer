//
//  MotivationSelectionPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol MotivationSelectionPresenterProtocol {
    func didSelectMotivationalItem(item: MotivationalItem)
    func didSelectPaidMotivation()
    func didSelectTimeMotivation()
    func didTapSaveButton()
}

class MotivatoinSelectionPresenter: MotivationSelectionPresenterProtocol {
    weak var view: MotivationSelectionViewProtocol?
    private let motivationalItemUseCase: ItemParameterUseCaseProtocol
    private var selectedItem: MotivationalItem?

    init(view: MotivationSelectionViewProtocol,
         motivationalItemUseCase: ItemParameterUseCaseProtocol) {
        self.view = view
        self.motivationalItemUseCase = motivationalItemUseCase

        motivationalItemUseCase.getSelected(completionHandler: { (selectedItemResult) in
            guard let selectedItem = try? selectedItemResult.get() else {
                assertionFailure()
                return
            }

            self.selectedItem = selectedItem
        })
    }

    func didSelectMotivationalItem(item: MotivationalItem) {
        motivationalItemUseCase.select(motivationalItem: item) { (_) in return }
    }

    func didSelectPaidMotivation() {
        // check if user has it
    }

    func didSelectTimeMotivation() {
        selectedItem = .ad
    }

    func didTapSaveButton() {
        guard let selectedItem = selectedItem else {
            assertionFailure()
            return
        }
        
        motivationalItemUseCase.select(motivationalItem: selectedItem) { (_) in return }
    }
}
