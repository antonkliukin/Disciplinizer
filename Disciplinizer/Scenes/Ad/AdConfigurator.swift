//
//  AdConfigurator.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 14.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

class AdConfigurator {
    func configure(adViewController: AdViewController) {
        let presenter = AdPresenter(view: adViewController)
        adViewController.presenter = presenter
    }
}
