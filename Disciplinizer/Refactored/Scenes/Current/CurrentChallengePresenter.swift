//
//  CurrentChallengePresenter.swift
//  Disciplinizer
//
//  Created by Alexander Bakhmut on 19.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import AVFoundation
import SwiftySound

protocol CurrentChallengePresenterProtocol: class {
    func didTapStopChallenge()
    func didTapMusicSelect()
    func didTapPlayButton()
    func viewDidLoad()
    func viewDidAppear()
}

final class CurrentChallengePresenter: CurrentChallengePresenterProtocol {
    
    weak var view: CurrentChallengeViewProtocol?

    private let startChallengeUseCase: StartChallengeUseCaseProtocol
    private let finishChallengeUseCase: FinishChallengeUseCaseProtocol
    
    private let challenge: Challenge
    private var challengeTimer: Timer?
    private var durationInSeconds = 0

    required init(view: CurrentChallengeViewProtocol,
                  challenge: Challenge,
                  startChallengeUseCase: StartChallengeUseCaseProtocol,
                  finishChallengeUseCase: FinishChallengeUseCaseProtocol) {
        self.view = view
        self.challenge = challenge
        self.durationInSeconds = Int(challenge.duration)
        self.startChallengeUseCase = startChallengeUseCase
        self.finishChallengeUseCase = finishChallengeUseCase
    }

    func viewDidLoad() {
        view?.updateTimer(time: convertSecondsToTimeString(durationInSeconds))
    }

    func viewDidAppear() {
        start(challenge)
    }
    
    func didTapStopChallenge() {
        invalidateTimer()

        // TODO: - Add confirmation alert
        view?.router?.dismiss(animated: true, completion: nil, toRoot: true)
        stopMusic()
        stopMutedPlayback()
    }

    func didTapMusicSelect() {
        let controller = Controller.createMusicSelect()
        controller.delegate = self
        view?.router?.present(controller)
    }
    
    func didTapPlayButton() {
        let soundManager = SoundManager.shared

        let didTapStop = SoundManager.shared.selectedSong?.sound?.playing ?? false

        if didTapStop {
            soundManager.stopSelected()

            startMutedPlayback()
        } else {
            soundManager.playSelected()
        }
    }
    
    @objc private func updateTimer() {
        durationInSeconds -= 1

        let timeString = convertSecondsToTimeString(durationInSeconds)

        view?.updateTimer(time: timeString)
    }
    
    private func invalidateTimer() {
        if let timer = challengeTimer {
            timer.invalidate()
        }
    }
    
    private func stopMusic() {
        SoundManager.shared.stopSelected()
    }

    private let defaultSound = Sound(url: R.file.pianoWav()!)

    private func startMutedPlayback() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
        } catch {
            assertionFailure("AVAudioSession error occured.")
        }

        Sound.category = .playback
        defaultSound?.volume = 0
        defaultSound?.play(numberOfLoops: -1)
    }

    private func stopMutedPlayback() {
        defaultSound?.stop()
    }

    private func start(_ challenge: Challenge) {
        print("New challenge has been started")

        startMutedPlayback()

        self.challengeTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                   target: self,
                                                   selector: #selector(self.updateTimer),
                                                   userInfo: nil,
                                                   repeats: true)

        startChallengeUseCase.start(challenge: challenge) { [weak self] (challengeResult) in
            guard let self = self else {
                assertionFailure()
                return
            }

            switch challengeResult {
            case .success(let finishedChallenge):
                self.saveFinishedChallenge(finishedChallenge)
            case .failure:
                 assertionFailure()
            }
        }
    }

    private func saveFinishedChallenge(_ challenge: Challenge) {
        finishChallengeUseCase.finish(challenge: challenge) { [weak self] (finishingResult) in
            guard let self = self else {
                assertionFailure()
                return
            }

            self.invalidateTimer()
            self.stopMusic()

            switch finishingResult {
            case .success(let finishedChallenge):
                let isLose = !finishedChallenge.isSuccess

                if isLose {
                    print("Lose")
                    AppLockManager.shared.changeStateTo(.locked)
                } else {
                    print("Win")
                }

                self.view?.router?.dismiss(animated: true, completion: nil, toRoot: true)
            case .failure:
                 assertionFailure()
            }
        }
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
