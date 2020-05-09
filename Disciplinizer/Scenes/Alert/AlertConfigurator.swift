//
//  AlertConfigurator.swift
//  Disciplinizer
//
//  Created by Anton on 03.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol AlertConfiguratorProtocol {
    func configure(alert: AlertViewController)
}

class AlertConfigurator: AlertConfiguratorProtocol {
    let model: AlertModel
    
    init(model: AlertModel) {
        self.model = model
    }

    func configure(alert: AlertViewController) {
        let presenter = AlertPresenter(view: alert, model: model)
        
        alert.presenter = presenter
    }
}
