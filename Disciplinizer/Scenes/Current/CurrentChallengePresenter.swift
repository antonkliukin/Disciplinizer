//
//  CurrentChallengePresenter.swift
//  Disciplinizer
//
//  Created by Alexander Bakhmut on 19.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol CurrentChallengePresenterProtocol: class {
    func viewDidLoad()
    func viewDidAppear()
    func didTapStopChallenge()
    func didTapMusicSelection()
    func didTapBackButton()

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
    
    private var motivationParameterUseCase: MotivationParameterUseCaseProtocol

    required init(view: CurrentChallengeViewProtocol,
                  challenge: Challenge,
                  startChallengeUseCase: StartChallengeUseCaseProtocol,
                  finishChallengeUseCase: FinishChallengeUseCaseProtocol,
                  changeMutedPlaybackStateUseCase: ChangeMutedPlaybackStateUseCaseProtocol,
                  motivationParameterUseCase: MotivationParameterUseCaseProtocol) {
        self.view = view
        self.challenge = challenge
        self.durationInSeconds = Int(challenge.durationInMinutes * 60)
        self.startChallengeUseCase = startChallengeUseCase
        self.finishChallengeUseCase = finishChallengeUseCase
        self.changeMutedPlaybackStateUseCase = changeMutedPlaybackStateUseCase
        self.motivationParameterUseCase = motivationParameterUseCase
    }

    func viewDidLoad() {
        view?.display(timerTitle: Strings.currentTimerTitle())
        view?.display(timerDescription: challenge.motivationalItem == .ad ? Strings.currentTimerAdDescription() : Strings.currentTimerCatDescription())
        view?.display(giveUpButtonTitle: Strings.currentGiveUpButtonTitle())
        
        setupMusicController()

        updateTimerView()
    }

    func viewDidAppear() {
        start(challenge)
    }
        
    func didTapStopChallenge() {
        let alertDescription = challenge.motivationalItem == .ad ? Strings.currentAlertGiveUpAdDescription() : Strings.currentAlertGiveUpCatDescription()
        
        let alertModel = AlertModel(title: Strings.currentAlertGiveUpTitle(),
                                    message: alertDescription,
                                    positiveActionTitle: Strings.currentAlertGiveUpPositive(),
                                    positiveAction: nil,
                                    negativeActionTitle: Strings.currentAlertGiveUpNegative(),
                                    negativeAction: {
                                        self.invalidateTimer()

                                        self.saveFinishedChallenge(self.challenge, withResult: .lose)

                                        self.view?.router?.dismiss()
        })
        
        let alert = Controller.createAlert(alertModel: alertModel)
        view?.router?.present(alert)
    }

    func didTapMusicSelection() {
        guard let vc = musicView as? MusicSelectViewController else {
            assertionFailure()
            return
        }

        view?.router?.present(vc)
    }
    
    func didTapBackButton() {
        view?.router?.dismiss()
    }

    private func setupMusicController() {
        let musicController = Controller.createMusicSelect()
        musicView = musicController
    }

    private func convertedToTimeUnits(timeInSeconds: Int) -> TimeUnits {
        let seconds = String(format: "%0.2d", timeInSeconds % 60)
        let minutes = String(format: "%0.2d", (timeInSeconds / 60) % 60)
        let hours = String(format: "%0.2d", timeInSeconds / 3600)
        
        return TimeUnits(seconds: seconds, minutes: minutes, hours: hours)
    }
    
    @objc private func updateTimer() {
        durationInSeconds -= 1

        updateTimerView()
        
        if durationInSeconds <= 0 {
            saveFinishedChallenge(challenge)
        }
    }
    
    private func invalidateTimer() {
        if let timer = challengeTimer {
            timer.invalidate()
            challengeTimer = nil
        }
    }

    private func fireLoseTimer(withInterval interval: Int) {
        guard challengeTimer != nil else { return }
        
        self.loseTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: false, block: { [weak self] (_) in
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
            print("> Background is legal")
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if UIApplication.shared.applicationState == .background {
                    NotificationManager.sendReturnToAppNotification()
                    self.fireLoseTimer(withInterval: 10)
                    print("> Background is NOT legal. Lose timer has been started.")
                }
            }
        }
    }

    func didReturnToApp() {
        print("Did return to the app")
        loseTimer?.invalidate()
        loseTimer = nil
    }

    func didCloseApp() {
        saveFinishedChallenge(challenge, withResult: .lose)
    }

    private func start(_ challenge: Challenge) {
        print("> New challenge has been started")

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
        challengeToSave.finishDate = Date()

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
                let adIsItem = finishedChallenge.motivationalItem == .ad

                if isLose, adIsItem {
                    AppLockManager.shared.changeStateTo(.locked)
                    KeychainService.appLockState = .locked
                    
                    print("> Lose, the app will be blocked until ad is viewed")
                } else if isLose {
                    self.motivationParameterUseCase.deletePaid { (_) in }
                    self.motivationParameterUseCase.select(motivationalItem: .ad) { (_) in }
                    AppLockManager.shared.changeStateTo(.locked)
                    KeychainService.appLockState = .locked

                    print("> Lose without blocking")
                } else {
                    DispatchQueue.main.async {
                        self.view?.display(congratsTitle: Strings.currentCongrats())
                        self.view?.display(backToMenuButtonTitle: Strings.currentBackButtonTitle())
                        self.view?.display(timerDescription: Strings.currentSuccessDescription())
                        self.view?.hideGiveUpButton()
                        self.view?.hideMusicSelectionButton()
                        
                        NotificationManager.sendSuccessNotification(keepInNotificationCenter: true)
                    }
                }
            case .failure:
                assertionFailure()
            }
        }
    }
    
    private func updateTimerView() {
        let timeUnits = convertedToTimeUnits(timeInSeconds: durationInSeconds)
        view?.updateTimer(timeUnits: timeUnits)
    }
}
