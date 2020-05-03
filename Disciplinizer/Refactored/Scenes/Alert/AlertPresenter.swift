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
    func didTapAlertAction()
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

    func didTapAlertAction() {
        view?.router?.dismiss()
        model.action?()
    }
}
