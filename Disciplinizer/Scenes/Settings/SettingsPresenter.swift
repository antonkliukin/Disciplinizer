//
//  SettingsPresenter.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 11.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol SettingsPresenterProtocol {
    func viewDidLoad()
}

final class SettingsPresenter: SettingsPresenterProtocol {
    weak var view: SettingsViewProtocol!

    required init(view: SettingsViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view.set(viewTitle: R.string.localizable.settingsTitle())
    }
}
