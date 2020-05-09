//
//  SettingsPresenter.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 11.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol SettingsPresenterProtocol {
    func didTapMusicSelect()
}

final class SettingsPresenter: SettingsPresenterProtocol {
    weak var view: SettingsViewProtocol!

    required init(view: SettingsViewProtocol) {
        self.view = view
    }
    
    func didTapMusicSelect() {
        let vc = Controller.createMusicSelect()

        self.view.router?.present(vc)
    }
}
