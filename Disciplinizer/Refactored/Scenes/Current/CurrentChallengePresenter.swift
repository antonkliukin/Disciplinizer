//
//  CurrentChallengePresenter.swift
//  Disciplinizer
//
//  Created by Alexander Bakhmut on 19.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

// MARK: - Current Challenge Presenter Protocol

protocol CurrentChallengePresenterProtocol: class {
    func didTapStopChallenge()
    func didTapMusicSelect()
    func didTapPlayButton()
    func viewDidLoad()
    func viewDidAppear()
}

// MARK: - Current Challenge Presenter

final class CurrentChallengePresenter: CurrentChallengePresenterProtocol {
    
    weak var view: CurrentChallengeViewProtocol?

    private let startChallengeUseCase: StartChallengeUseCaseProtocol
    private let updateChallengeUseCase: UpdateChallengeUseCaseProtocol
    
    private let challenge: Challenge
    private var challengeTimer: Timer?
    private var durationInSeconds = 0

    required init(view: CurrentChallengeViewProtocol,
                  challenge: Challenge,
                  startChallengeUseCase: StartChallengeUseCaseProtocol,
                  updateChallengeUseCase: UpdateChallengeUseCaseProtocol) {
        self.view = view
        self.challenge = challenge
        self.durationInSeconds = Int(challenge.duration)
        self.startChallengeUseCase = startChallengeUseCase
        self.updateChallengeUseCase = updateChallengeUseCase
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

    private func start(_ challenge: Challenge) {
        print("New challenge has been started")

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
        updateChallengeUseCase.update(challenge: challenge) { [weak self] (updateResult) in
            guard let self = self else {
                assertionFailure()
                return
            }

            self.invalidateTimer()
            self.stopMusic()

            switch updateResult {
            case .success(let updatedChallenge):
                let isLose = !updatedChallenge.isSuccess

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
