//
//  SoundManager.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 19.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

final class SoundManager {
    static let shared = SoundManager()
    var selectedSong: SongModel? {
        willSet {
             stopSelected()
        }
    }
    
    init() {
        guard let songURL = R.file.birds0Mp3() else { return }
        selectedSong = SongModel(title: Strings.songNamesPillowTalk(), url: songURL)
    }
    
    func playSelected() {
        selectedSong?.sound?.play(numberOfLoops: -1)
    }
    
    func stopSelected() {
        selectedSong?.sound?.stop()
    }
}
