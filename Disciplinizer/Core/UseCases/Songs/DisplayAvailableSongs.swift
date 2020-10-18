//
//  DisplayAvailableSongs.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 12.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol DisplaySongsUseCaseProtocol {
    func getAll(completionHandler: @escaping (_ songs: Result<[Song], Error>) -> Void)
}

class DisplaySongsUseCase: DisplaySongsUseCaseProtocol {
    let songsGateway: SongsGatewayProtocol

    init(songsGateway: SongsGatewayProtocol) {
        self.songsGateway = songsGateway
    }

    func getAll(completionHandler: @escaping (_ challenge: Result<[Song], Error>) -> Void) {
        songsGateway.getAll(completionHandler: completionHandler)
    }
}
