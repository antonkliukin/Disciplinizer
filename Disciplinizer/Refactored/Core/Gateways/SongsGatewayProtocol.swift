//
//  SongsGatewayProtocol.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 12.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol SongsGatewayProtocol {
    func getAll(completionHandler: @escaping (_ songs: Result<[Song], Error>) -> Void)
    func play(song: Song, withVolume volume: Float, completionHandler: @escaping (_ result: Result<Void, Error>) -> Void)
    func startMutedPlayback(completionHandler: @escaping (Result<Void, Error>) -> Void)
    func stopMutedPlayback(completionHandler: @escaping (Result<Void, Error>) -> Void)
    func stop(song: Song, completionHandler: @escaping (_ result: Result<Void, Error>) -> Void)
    func setVolume(value: Float, completionHandler: @escaping (_ result: Result<Void, Error>) -> Void)
}
