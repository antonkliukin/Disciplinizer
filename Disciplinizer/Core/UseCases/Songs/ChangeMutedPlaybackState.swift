//
//  ChangeMutedPlaybackState.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 14.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol ChangeMutedPlaybackStateUseCaseProtocol {
    func startMutedPlayback(completionHandler: @escaping (Result<Void, Error>) -> Void)
    func stopMutedPlayback(completionHandler: @escaping (Result<Void, Error>) -> Void)
}

class ChangeMutedPlaybackStateUseCase: ChangeMutedPlaybackStateUseCaseProtocol {
    let songsGateway: SongsGatewayProtocol

    init(songsGateway: SongsGatewayProtocol) {
        self.songsGateway = songsGateway
    }

    func startMutedPlayback(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        songsGateway.startMutedPlayback(completionHandler: completionHandler)
    }

    func stopMutedPlayback(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        songsGateway.stopMutedPlayback(completionHandler: completionHandler)
    }
}
