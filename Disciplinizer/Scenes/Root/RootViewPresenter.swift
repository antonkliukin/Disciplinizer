//
//  RootViewPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 05.10.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol RootViewPresenterProtocol {
    func viewDidLoad()
}

final class RootViewPresenter: RootViewPresenterProtocol {
    weak var view: RootViewProtocol?
    var displayMotivationalItemsUseCase: DisplayMotivationalItemsUseCaseProtocol

    init(view: RootViewProtocol,
         displayMotivationalItemsUseCase: DisplayMotivationalItemsUseCaseProtocol) {
        self.view = view
        self.displayMotivationalItemsUseCase = displayMotivationalItemsUseCase
    }
    
    func viewDidLoad() {
        displayMotivationalItemsUseCase.displayItems { (result) in
            switch result {
            case .success(let items):
                print(items)
            case .failure:
                assertionFailure()
            }
        }
    }
}
