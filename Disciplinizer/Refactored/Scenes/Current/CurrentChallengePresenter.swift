//
//  CurrentChallengePresenter.swift
//  Disciplinizer
//
//  Created by Alexander Bakhmut on 19.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol CurrentChallengePresenterProtocol: class {
    func viewDidLoad()
    func viewDidAppear()
    func didTapStopChallenge()
    func didTapMusicSelection()

    func willLeaveApp()
    func didLeaveApp()
    func didCloseApp()
    func didReturnToApp()
}

final class CurrentChallengePresenter: CurrentChallengePresenterProtocol {
    
    weak var view: CurrentChallengeViewProtocol?
    var musicView: MusicSelectionViewProtocol?

    private let startChallengeUseCase: StartChallengeUseCaseProtocol
    private let finishChallengeUseCase: FinishChallengeUseCaseProtocol
    private let changeMutedPlaybackStateUseCase: ChangeMutedPlaybackStateUseCaseProtocol

    private let challenge: Challenge
    private var challengeTimer: Timer?
    private var durationInSeconds = 0

    private var loseTimer: Timer?
    private var willLeaveAppTimestampDate: Date?

    required init(view: CurrentChallengeViewProtocol,
                  challenge: Challenge,
                  startChallengeUseCase: StartChallengeUseCaseProtocol,
                  finishChallengeUseCase: FinishChallengeUseCaseProtocol,
                  changeMutedPlaybackStateUseCase: ChangeMutedPlaybackStateUseCaseProtocol) {
        self.view = view
        self.challenge = challenge
        self.durationInSeconds = Int(challenge.duration)
        self.startChallengeUseCase = startChallengeUseCase
        self.finishChallengeUseCase = finishChallengeUseCase
        self.changeMutedPlaybackStateUseCase = changeMutedPlaybackStateUseCase
    }

    func viewDidLoad() {
        setupMusicController()

        view?.updateTimer(time: convertSecondsToTimeString(durationInSeconds))
    }

    func viewDidAppear() {
        start(challenge)
    }
    
    func didTapStopChallenge() {
        invalidateTimer()

        // TODO: - Add confirmation alert
        saveFinishedChallenge(challenge, withResult: .lose)
    }

    func didTapMusicSelection() {
        guard let vc = musicView as? MusicSelectViewController else {
            assertionFailure()
            return
        }

        view?.router?.present(vc)
    }

    private func setupMusicController() {
        let musicController = Controller.createMusicSelect()
        musicView = musicController
    }

    private func convertSecondsToTimeString(_ timeInSeconds: Int) -> String {
        let seconds = timeInSeconds % 60
        let minutes = (timeInSeconds / 60) % 60
        let hours = timeInSeconds / 3600
        let timeString = String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)

        return timeString
    }
    
    @objc private func updateTimer() {
        durationInSeconds -= 1

        let timeString = convertSecondsToTimeString(durationInSeconds)

        view?.updateTimer(time: timeString)

        if durationInSeconds <= 0 {
            saveFinishedChallenge(challenge)
        }
    }
    
    private func invalidateTimer() {
        if let timer = challengeTimer {
            timer.invalidate()
        }
    }

    private func isBackgroundLegal(handler: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if !(self.view?.isDeviceLocked ?? false) {
                NotificationManager.sendReturnToAppNotification()
                handler(false)
            } else {
                print("Device was locked")
                handler(true)
            }
        }
    }

    private func fireLoseTimer(withInterval interval: TimeInterval) {
        self.loseTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { [weak self] (_) in
            guard let self = self else {
                assertionFailure()
                return
            }

            self.saveFinishedChallenge(self.challenge, withResult: .lose)
        })
    }

    func willLeaveApp() {
        willLeaveAppTimestampDate = Date()
    }

    func didLeaveApp() {
        guard let willLeaveAppTimestampDate = willLeaveAppTimestampDate else { return }

        // TODO: Legal BG check - Version 2
        let timeSinceResign = Date().timeIntervalSince(willLeaveAppTimestampDate)
        let wasPowerPressed = timeSinceResign < 0.1

        if wasPowerPressed {
            print("Background is legal")
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NotificationManager.sendReturnToAppNotification()
                self.fireLoseTimer(withInterval: 10)
                print("Background is NOT legal. Lose timer has been started.")
            }
        }

//         TODO: Legal BG check - Version 1
//        isBackgroundLegal { (isLegal) in
//            if isLegal {
//                print("Background is legal")
//            } else {
//                self.fireLoseTimer(withInterval: 10)
//                print("Background is NOT legal. Lose timer has been started.")
//            }
//        }
    }

    func didReturnToApp() {
        loseTimer?.invalidate()
    }

    func didCloseApp() {
        saveFinishedChallenge(challenge, withResult: .lose)
    }

    private func start(_ challenge: Challenge) {
        print("New challenge has been started")

        self.changeMutedPlaybackStateUseCase.startMutedPlayback { (_) in return }

        self.challengeTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                   target: self,
                                                   selector: #selector(self.updateTimer),
                                                   userInfo: nil,
                                                   repeats: true)
    }

    private func saveFinishedChallenge(_ challenge: Challenge, withResult result: ChallengeResult = .win) {
        var challengeToSave = challenge

        let isWin = result == .win
        challengeToSave.isSuccess = isWin

        finishChallengeUseCase.finish(challenge: challengeToSave) { [weak self] (finishingResult) in
            guard let self = self else {
                assertionFailure()
                return
            }

            self.invalidateTimer()
            self.changeMutedPlaybackStateUseCase.stopMutedPlayback { (_) in return }

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
