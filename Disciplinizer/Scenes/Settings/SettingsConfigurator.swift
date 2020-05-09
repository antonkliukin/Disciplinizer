//
//  SettingsConfigurator.swift
//  Disciplinizer
//
//  Created by Anton on 05.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol SettingsConfiguratorProtocol {
    func configure(settingsViewController: SettingsViewController)
}

final class SettingsConfigurator: SettingsConfiguratorProtocol {
    func configure(settingsViewController: SettingsViewController) {
        let presenter = SettingsPresenter(view: settingsViewController)
        settingsViewController.presenter = presenter
    }
}
