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
        vc.delegate = self
        self.view.router?.present(vc)
    }
}

extension SettingsPresenter: MusicSelectViewDelegate {
    func didSelect(song: SongModel?) {
        if let song = song {
            view.updateMusicConfiguration(with: song)
        }
    }
}
