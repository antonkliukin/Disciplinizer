//
//  CurrentChallengePresenter.swift
//  Concentration tracker
//
//  Created by Alexander Bakhmut on 19.10.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import Foundation

// MARK: - Current Challenge Presenter Protocol

protocol CurrentChallengePresenterProtocol: class {
    func didTapStopChallenge()
    func didTapMusicSelect()
    func didTapPlayButton()
    func viewWillAppear()
    func viewDidLoad()
}

// MARK: - Current Challenge Presenter

final class CurrentChallengePresenter: CurrentChallengePresenterProtocol {
    
    weak var view: CurrentChallengeViewProtocol?
    
    private let challenge: Challenge
    private var challengeTimer: Timer?
    private var durationInSeconds = 0
    private var didTapGiveUp: () -> Void
    
    required init(view: CurrentChallengeViewProtocol, challenge: Challenge, didTapGiveUp: @escaping () -> Void) {
        self.view = view
        self.challenge = challenge
        durationInSeconds = Int(challenge.duration)
        self.didTapGiveUp = didTapGiveUp
    }

    func viewDidLoad() {
        view?.updateTimer(time: convertSecondsToTimeString(durationInSeconds))
    }

    func viewWillAppear() {
        challengeTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(updateTimer),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    func didTapStopChallenge() {
        invalidateTimer()
        didTapGiveUp()
        // TODO: - Add confirmation alert
        view?.router?.dismiss(animated: true, completion: nil, toRoot: true)
        stopMusic()
    }
    
    func didTapMusicSelect() {
        let controller = Controller.createMusicSelect()
        controller.delegate = self
        view?.router?.present(controller)
    }
    
    func didTapPlayButton() {
        let soundManager = SoundManager.shared
        (SoundManager.shared.selectedSong?.sound?.playing ?? false) ? soundManager.stopSelected() : soundManager.playSelected()
    }
    
    @objc private func updateTimer() {
        if durationInSeconds != 0 {
            durationInSeconds -= 1
            
            let timeString = convertSecondsToTimeString(durationInSeconds)

            view?.updateTimer(time: timeString)
        } else {
            invalidateTimer()
            view?.router?.dismiss(animated: true, completion: nil, toRoot: true)
            stopMusic()
        }
    }
    
    private func invalidateTimer() {
        if let timer = challengeTimer {
            timer.invalidate()
        }
    }
    
    private func stopMusic() {
        SoundManager.shared.stopSelected()
    }
}

extension CurrentChallengePresenter: MusicSelectViewDelegate {
    func didSelect(song: SongModel?) {
        SoundManager.shared.playSelected()
        view?.updatePlayButton()
    }
    
    func convertSecondsToTimeString(_ timeInSeconds: Int) -> String {
        let seconds = timeInSeconds % 60
        let minutes = (timeInSeconds / 60) % 60
        let hours = timeInSeconds / 3600
        let timeString = String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        
        return timeString
    }
}
