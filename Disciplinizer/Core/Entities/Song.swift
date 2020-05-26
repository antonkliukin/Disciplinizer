//
//  SongModel.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 13.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

struct Song {
    let title: String
    let url: URL
    var isPlaying = false
}

extension Song: Equatable {
    static func == (lhs: Song, rhs: Song) -> Bool {
        // TODO: Better to compare ids as url isn't reliable
        return lhs.url == rhs.url
    }
}
