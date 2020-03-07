//
//  CreateChallengePresenter.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 09/10/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import AVFoundation
import SwiftySound

protocol CreateChallengePresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func startButtonTapped()
    func didChooseMode(_ mode: ChallengeMode)
    //func didSetTimer(withTimeInMinutes minutes: Double)
}

final class CreateChallengePresenter: CreateChallengePresenterProtocol {
    private weak var view: CreateChallengeViewProtocol?
    private let addChallengeUseCase: AddChallengeUseCaseProtocol

    private var purchaseManager: PurchasesManagerProtocol?
    private var possibleBets: [BetProtocol] = []
    private var newChallenge: Challenge!

    private var activeChallengeTimer: Timer?
    private var defaultTestDuration: TimeInterval = 30

    private let defaultSound = Sound(url: R.file.pianoWav()!)

    init(view: CreateChallengeViewProtocol,
         addChallengeUseCase: AddChallengeUseCaseProtocol) {
        self.view = view
        self.addChallengeUseCase = addChallengeUseCase
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

        purchaseManager?.getAvailiableBets { [weak self] (bets) in
            self?.view?.setupBetSlider(withPossibleBets: bets)
        }
    }

    func viewWillAppear() {
        view?.changeStartButtonState(isActive: !(view?.selectedMode == nil))
    }

    private var selectedDurationInSeconds: Double {
        guard let selectedDuration = view?.selectedDuration else {
            assertionFailure()
            return 0
        }

        // TODO: For test
        return 60 //selectedDuration * 60
    }

    private var selectedMode: ChallengeMode {
        guard let selectedMode = view?.selectedMode else {
            assertionFailure()
            return .free
        }

        if selectedMode == .paid, !NetworkState.isConnected {
            // TODO: Show alert
            assertionFailure("Should not be possible to use paid without internet")
        }

        return selectedMode
    }

    func didChooseMode(_ mode: ChallengeMode) {
        view?.changeStartButtonState(isActive: true)
    }

    func startButtonTapped() {
        // TODO: Check if notifications are enabled. If not, how alert redirecting user to notif settings

        guard !isChallengeRunning else {
            assertionFailure("Should not be possible")
            return
        }

        let isPaid = selectedMode == .paid
        let betId = isPaid ? view?.selectedBetId : nil
        let addParameters = AddChallengeParameters(startDate: Date(),
                                                   finishDate: nil,
                                                   duration: selectedDurationInSeconds,
                                                   isSuccess: false,
                                                   isPaid: isPaid,
                                                   betId: betId)

        view?.changeStartButtonState(isActive: false)
        startMutedPlayback()

        addChallengeUseCase.add(parameters: addParameters) { [weak self] (addingResult) in
            guard let self = self else {
                assertionFailure()
                return
            }

            switch addingResult {
            case .success(let addedChallenge):
                self.view?.router?.present(Controller.currentChallenge(with: addedChallenge))
            case .failure:
                assertionFailure()
            }
        }
    }
}
