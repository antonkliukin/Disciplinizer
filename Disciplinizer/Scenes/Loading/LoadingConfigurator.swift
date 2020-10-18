//
//  LoadingConfigurator.swift
//  Disciplinizer
//
//  Created by Anton on 03.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol LoadingConfiguratorProtocol {
    func configure(loadingViewController: LoadingViewController)
}

class LoadingConfigurator: LoadingConfiguratorProtocol {

    func configure(loadingViewController: LoadingViewController) {
        let presenter = LoadingPresenter(view: loadingViewController)
        
        loadingViewController.presenter = presenter
    }
}
