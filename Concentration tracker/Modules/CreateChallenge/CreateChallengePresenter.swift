//
//  CreateChallengePresenter.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 09/10/2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import AVFoundation
import SwiftySound

protocol CreateChallengePresenterProtocol {
    func viewDidLoad()
    func startButtonTapped()
    func didChooseMode(_ mode: ChallengeMode)
    func didSetTimer(withTimeInMinutes minutes: Double)
}

final class CreateChallengePresenter: CreateChallengePresenterProtocol {
    private weak var view: CreateChallengeViewProtocol?
    private var challengeManager: ChallengeManager
    private var purchaseManager: PurchasesManagerProtocol
    private var possibleBets: [BetProtocol] = []
    private var newChallenge: Challenge!

    private var activeChallengeTimer: Timer?
    private var defaultTestDuration: TimeInterval = 30
    private var challengeDurationInSeconds: TimeInterval!

    private let defaultSound = Sound(url: R.file.pianoWav()!)

    init(view: CreateChallengeViewProtocol, challengeManager: ChallengeManager, purchaseManager: PurchasesManagerProtocol) {
        self.view = view
        self.challengeManager = challengeManager
        self.purchaseManager = purchaseManager
    }

    private func startMutedPlayback() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
        } catch {
            fatalError("AVAudioSession error occured.")
        }

        Sound.category = .playback
        defaultSound?.volume = 0
        defaultSound?.play(numberOfLoops: -1)
    }

    private func stopPlayback() {
        defaultSound?.pause()
    }

    func viewDidLoad() {
        view?.changeStartButtonState(isActive: false)

        purchaseManager.getAvailiableBets { [weak self] (bets) in
            self?.view?.setupBetSlider(withPossibleBets: bets)
        }
    }

    func didChooseMode(_ mode: ChallengeMode) {
        if mode == .paid, !NetworkState.isConnected {
            // TODO: Show alert
            assertionFailure("Should not be possible to use paid without internet")
        }

        view?.changeStartButtonState(isActive: true)
    }

    func didSetTimer(withTimeInMinutes minutes: Double) {
        challengeDurationInSeconds = minutes * 60
        newChallenge?.duration = challengeDurationInSeconds
    }

    func startButtonTapped() {
        guard !isChallengeRunning else {
            assertionFailure("Should not be possible")
            return
        }

//        guard let mode = view?.selectedMode else {
//            // TODO: Add alert
//            assertionFailure("Show alert suggesting to choose mode")
//            return
//        }

        // let isPaid = mode == .paid
        // let betId = isPaid ? view?.selectedBetId : nil
        newChallenge = Challenge(id: "0",
                                 startDate: Date(),
                                 finishDate: nil,
                                 duration: 100,
                                 isSuccess: false,
                                 isPaid: false,
                                 betId: "0")

        challengeDurationInSeconds = defaultTestDuration
        view?.changeStartButtonState(isActive: false)
        startMutedPlayback()

        let startResult = challengeManager.start(newChallenge) { (challengeResult) in
            switch challengeResult {
            case .win:
                print("win")
            case .lose:
                AppLockManager.shared.changeStateTo(.locked)
                let losingVC = Controller.createLosing(withFailedChallenge: self.newChallenge)
                self.view?.router?.present(losingVC, animated: true, forcePresent: true, completion: nil)

                print("lose")
            }

            self.activeChallengeTimer?.invalidate()
            self.newChallenge = nil
            self.stopPlayback()
            self.view?.changeStartButtonState(isActive: true)
        }

        switch startResult {
        case .success:
            view?.router?.present(Controller.currentChallenge(with: newChallenge, didTapGiveUp: { [weak self] in
                self?.challengeManager.finishCurrentWith(result: .lose)
            }))

            print("New challenge has been started")
        case .failure(let error):
            // TODO: Show alert redirecting user to notif settings
            print(error)
        }
    }
}
