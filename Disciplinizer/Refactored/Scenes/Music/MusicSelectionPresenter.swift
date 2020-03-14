//
//  MusicSelectPresenter.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 13.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol MusicSelectionPresenterProtocol {
    func viewDidLoad()
    func didSelect(song: Song)
}

final class MusicSelectionPresenter: MusicSelectionPresenterProtocol {
    
    weak var view: MusicSelectionViewProtocol!

    private var changePlaybackStateUseCase: ChangePlaybackStateUseCaseProtocol
    private var displaySongsUseCase: DisplaySongsUseCaseProtocol
    
    init(view: MusicSelectionViewProtocol,
         changePlaybackStateUseCase: ChangePlaybackStateUseCaseProtocol,
         displaySongsUseCase: DisplaySongsUseCaseProtocol) {
        self.view = view
        self.changePlaybackStateUseCase = changePlaybackStateUseCase
        self.displaySongsUseCase = displaySongsUseCase
    }

    func viewDidLoad() {
        displaySongsUseCase.getAll { (getSongsResult) in
            guard let songs = try? getSongsResult.get() else {
                assertionFailure()
                return
            }

            self.view.setupSongsList(songs: songs)
        }
    }
    
    func didSelect(song: Song) {
        view.router?.dismiss()

        changePlaybackStateUseCase.play(song: song, withVolume: 1) { (_) in return }
    }
}
