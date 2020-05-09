//
//  AlertPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 24/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol AlertPresenterProtocol {
    func viewDidLoad()
    func didTapPositiveAlertAction()
    func didTapNegativeAlertAction()
}

class AlertPresenter: AlertPresenterProtocol {
    weak var view: AlertViewProtocol?
    
    let model: AlertModel
    
    init(view: AlertViewProtocol,
         model: AlertModel) {
        self.view = view
        self.model = model
    }
    
    func viewDidLoad() {
        view?.configure(model)
    }

    func didTapPositiveAlertAction() {
        view?.router?.dismiss()
        model.positiveAction?()
    }
    
    func didTapNegativeAlertAction() {
        view?.router?.dismiss()
        model.negativeAction?()
    }
}
