//
//  SongModel.swift
//  Concentration tracker
//
//  Created by Лаки Ийнбор on 13.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation
import SwiftySound

final class SongModel {
    let title: String
    let url: URL
    
    init(title: String, url: URL) {
        self.title = title
        self.url = url
    }
    
    lazy var sound: Sound? = {
        let url = self.url
        let sound = Sound(url: url)
        sound?.volume = 1
        return sound
    }()
}
