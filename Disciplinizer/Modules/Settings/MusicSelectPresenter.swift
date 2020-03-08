//
//  MusicSelectPresenter.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 13.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol MusicSelectPresenterProtocol {
    var songModels: [SongModel] { get }
    func didSelect(song: SongModel?)
}

final class MusicSelectPresenter: MusicSelectViewProtocol {
    private let songsNames = [Strings.songNamesPillowTalk(),
                              Strings.songNamesLongDays(),
                              Strings.songNamesDistantPlace(),
                              Strings.songNamesFloatingPoint(),
                              Strings.songNamesMettingSun(),
                              Strings.songNamesLeavingWonderland()]
    
    private let songFiles = [R.file.birds0Mp3(),
                             R.file.birds1Mp3(),
                             R.file.space0Mp3(),
                             R.file.space1Mp3(),
                             R.file.water0Mp3(),
                             R.file.water1Mp3()]
    
    lazy var songModels: [SongModel] = {
        return zip(songsNames, songFiles).map { SongModel(title: $0.0, url: $0.1!) }
    }()
    
    weak var view: MusicSelectViewProtocol!
    
    init(view: MusicSelectViewProtocol) {
        self.view = view
    }
    
    func didSelect(song: SongModel?) {
        view.router?.dismiss()
    }
}
