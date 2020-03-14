//
//  ChangePlaybackState.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 12.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol ChangePlaybackStateUseCaseProtocol {
    func play(song: Song, withVolume volume: Float, completionHandler: @escaping (_ result: Result<Void, Error>) -> Void)
    func stop(song: Song, completionHandler: @escaping (_ result: Result<Void, Error>) -> Void)
    func setVolume(value: Float, completionHandler: @escaping (_ result: Result<Void, Error>) -> Void)
}

class ChangePlaybackStateUseCase: ChangePlaybackStateUseCaseProtocol {
    let songsGateway: SongsGatewayProtocol

    init(songsGateway: SongsGatewayProtocol) {
        self.songsGateway = songsGateway
    }

    func play(song: Song, withVolume volume: Float, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        songsGateway.play(song: song, withVolume: volume, completionHandler: completionHandler)
    }

    func stop(song: Song, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        songsGateway.stop(song: song, completionHandler: completionHandler)
    }

    func setVolume(value: Float, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        songsGateway.setVolume(value: value, completionHandler: completionHandler)
    }
}
