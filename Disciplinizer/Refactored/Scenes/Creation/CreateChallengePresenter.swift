//
//  CreateChallengePresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 09/10/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol CreateChallengePresenterProtocol {
    func viewDidLoad()
    func startButtonTapped()
    func didChooseMode(_ mode: ChallengeMode)
    func didSetTimer(withTimeInMinutes minutes: Int)
}

final class CreateChallengePresenter: CreateChallengePresenterProtocol {
    private weak var view: CreateChallengeViewProtocol?
    private let createChallengeUseCase: CreateChallengeUseCaseProtocol

    private var purchaseManager = PurchasesManager()
    private var possibleBets: [BetProtocol] = []
    private var newChallenge: Challenge!

    init(view: CreateChallengeViewProtocol,
         createChallengeUseCase: CreateChallengeUseCaseProtocol) {
        self.view = view
        self.createChallengeUseCase = createChallengeUseCase
    }

    func viewDidLoad() {
        view?.changeStartButtonState(isActive: !(view?.selectedMode == nil))

        purchaseManager.getAvailiableBets { [weak self] (bets) in
            self?.view?.setupBetSelector(withPossibleBets: bets)
        }
    }

    private var selectedDurationInSeconds: Double {
        guard let selectedDuration = view?.selectedDuration else {
            assertionFailure()
            return 0
        }

        // TODO: Test duration
        return 600 //selectedDuration * 60
    }

    private var selectedMode: ChallengeMode {
        guard let selectedMode = view?.selectedMode else {
            assertionFailure()
            return .free
        }

        return selectedMode
    }

    func didChooseMode(_ mode: ChallengeMode) {
        view?.changeStartButtonState(isActive: true)
    }

    func didSetTimer(withTimeInMinutes minutes: Int) {}

    func startButtonTapped() {
        // TODO: Check if notifications are enabled. If not, show alert redirecting user to notif settings
        let isNotifEnabled = NotificationManager.shared.isAuthorized()

        guard isNotifEnabled else {
            assertionFailure()
            return
        }

        view?.changeStartButtonState(isActive: false)

        createChallenge()
    }

    private func createChallenge() {
        let isPaid = selectedMode == .paid
        let betId = isPaid ? view?.selectedBetId : nil
        let challengeParameters = ChallengeParameters(startDate: Date(),
                                                      finishDate: nil,
                                                      duration: selectedDurationInSeconds,
                                                      isSuccess: false,
                                                      isPaid: isPaid,
                                                      betId: betId)

        createChallengeUseCase.createWith(parameters: challengeParameters) { [weak self] (creationResult) in
            guard let self = self else {
                assertionFailure()
                return
            }

            switch creationResult {
            case .success(let createdChallenge):
                self.view?.router?.present(Controller.currentChallenge(with: createdChallenge))
            case .failure:
                assertionFailure()
            }
        }
    }
}
