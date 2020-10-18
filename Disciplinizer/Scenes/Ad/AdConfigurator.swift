//
//  AdConfigurator.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 14.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

class AdConfigurator {
    weak var adDismissDelegate: AdDismissDelegateProtocol!
    
    init(adDismissDelegate: AdDismissDelegateProtocol) {
        self.adDismissDelegate = adDismissDelegate
    }
    
    func configure(adViewController: AdViewController) {
        let presenter = AdPresenter(view: adViewController, adDismissDelegate: adDismissDelegate)
        adViewController.presenter = presenter
    }
}
