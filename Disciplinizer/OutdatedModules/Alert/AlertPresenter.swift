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
    func didTapDismiss()
}

class AlertPresenter: AlertPresenterProtocol {
    weak var view: AlertViewProtocol?
    let message: String

    required init(view: AlertViewProtocol, message: String) {
        self.view = view
        self.message = message
    }

    func viewDidLoad() {
        view?.setMessageText(message)
    }

    func didTapDismiss() {
        view?.router?.dismiss()
    }
}
