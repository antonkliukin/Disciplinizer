//
//  MusicSelectionConfigurator.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 14.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol MusicSelectionConfiguratorProtocol {
    func configure(musicSelectionViewController: MusicSelectViewController)
}

class MusicSelectionConfigurator: MusicSelectionConfiguratorProtocol {

    func configure(musicSelectionViewController: MusicSelectViewController) {
        let songsGateway = SongsGateway()

        let changePlaybackStateUseCase = ChangePlaybackStateUseCase(songsGateway: songsGateway)
        let displaySongsUseCase = DisplaySongsUseCase(songsGateway: songsGateway)

        let presenter = MusicSelectionPresenter(view: musicSelectionViewController,
                                                changePlaybackStateUseCase: changePlaybackStateUseCase,
                                                displaySongsUseCase: displaySongsUseCase)

        musicSelectionViewController.presenter = presenter
    }
}
