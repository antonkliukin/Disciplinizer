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
    func dismiss()
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
        view.display(title: Strings.musicTitle())
        
        displaySongsUseCase.getAll { (getSongsResult) in
            guard let songs = try? getSongsResult.get() else {
                assertionFailure()
                return
            }

            self.view.setupSongsList(songs: songs)
        }
    }
    
    func didSelect(song: Song) {
        changePlaybackStateUseCase.getPlaying { (result) in
            switch result {
            case .success(let currentSong):
                guard let currentSong = currentSong else {
                    self.changePlaybackStateUseCase.play(song: song, withVolume: 1) { (_) in return }
                    return
                }
                
                if currentSong == song {
                    self.changePlaybackStateUseCase.stop(song: currentSong) { (_) in return }
                } else {
                    self.changePlaybackStateUseCase.stop(song: currentSong) { (_) in return }
                    self.changePlaybackStateUseCase.play(song: song, withVolume: 1) { (_) in return }
                }
            case .failure:
                assertionFailure()
            }
        }
    }
    
    func dismiss() {
        view.router?.dismiss()
    }
}
