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
    
    private var changePlaybackStateUseCase: ChangePlaybackStateUseCaseProtocol
    private var displaySongsUseCase: DisplaySongsUseCaseProtocol
    
    init(changePlaybackStateUseCase: ChangePlaybackStateUseCaseProtocol,
         displaySongsUseCase: DisplaySongsUseCaseProtocol) {
        self.changePlaybackStateUseCase =  changePlaybackStateUseCase
        self.displaySongsUseCase = displaySongsUseCase
    }

    func configure(musicSelectionViewController: MusicSelectViewController) {
        let presenter = MusicSelectionPresenter(view: musicSelectionViewController,
                                                changePlaybackStateUseCase: changePlaybackStateUseCase,
                                                displaySongsUseCase: displaySongsUseCase)

        musicSelectionViewController.presenter = presenter
    }
}
