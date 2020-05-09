//
//  MusicGateway.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 12.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import SwiftySound
import AVFoundation

class SongsGateway: SongsGatewayProtocol {
    var currentSong: Song?
    var currentSound: Sound?
    var currentMutedSong: Sound?

    func getAll(completionHandler: @escaping (Result<[Song], Error>) -> Void) {
        var songsToReturn: [Song] = []

        let fileManager = FileManager.default
        let bundle = Bundle.main
        let songPaths = bundle.paths(forResourcesOfType: "mp3", inDirectory: nil)

        for path in songPaths {
            let rawTitle = fileManager.displayName(atPath: path)
            let title = rawTitle.components(separatedBy: ".").first ?? ""

            let song = Song(title: title, url: URL(fileURLWithPath: path))
            songsToReturn.append(song)
        }

        completionHandler(.success(songsToReturn))
    }

    func startMutedPlayback(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let songURL = R.file.floatingPointMp3() else {
            assertionFailure()
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
        } catch {
            assertionFailure("AVAudioSession error occured.")
        }

        let sound = Sound(url: songURL)
        sound?.volume = 0
        sound?.play(numberOfLoops: -1)

        currentMutedSong = sound
    }

    func stopMutedPlayback(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        currentMutedSong?.stop()
        currentMutedSong = nil
    }

    func play(song: Song, withVolume volume: Float, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        currentSong = song

        let sound = Sound(url: song.url)
        currentSound = sound
        sound?.volume = volume
        sound?.play(numberOfLoops: -1)
    }

    func stop(song: Song, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        currentSong = nil
        
        currentSound?.stop()
        currentSound = nil
    }

    func setVolume(value: Float, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        currentSound?.volume = value
    }
    
    func getPlaying(completionHandler: @escaping (Result<Song?, Error>) -> Void) {
        completionHandler(.success(currentSong))
    }
}
