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
    private let motivationalItemUseCase: ItemParameterUseCaseProtocol
    private let durationParameterUseCase: DurationParameterUseCaseProtocol

    private var purchaseManager = PurchasesManager()
    private var possibleBets: [BetProtocol] = []
    private var newChallenge: Challenge!

    init(view: CreateChallengeViewProtocol,
         createChallengeUseCase: CreateChallengeUseCaseProtocol,
         motivationalItemUseCase: ItemParameterUseCaseProtocol,
         durationParameterUseCase: DurationParameterUseCaseProtocol) {
        self.view = view
        self.createChallengeUseCase = createChallengeUseCase
        self.motivationalItemUseCase = motivationalItemUseCase
        self.durationParameterUseCase = durationParameterUseCase
    }

    func viewDidLoad() {
        view?.changeStartButtonState(isActive: !(view?.selectedMode == nil))
        
        configureTimeView()
        configureMotivationView()
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
    
    func configureTimeView() {
        let timeViewModel = ParameterViewModel(title: Strings.creationTimeTitle(),
                                               valueTitle: "Value",
                                               actionTitle: Strings.creationActionTitle(),
                                               action: {
                                                let selectTimeVC = Controller.timeSelection()
                                                self.view?.router?.push(selectTimeVC)
        })
        
        view?.configureTimeView(model: timeViewModel)
    }
    
    func configureMotivationView() {
        let motivationViewModel = ParameterViewModel(title: Strings.creationMotivationTitle(),
                                                     valueTitle: "Value",
                                                     actionTitle: Strings.creationActionTitle(),
                                                     action: {
                                                        let selectMotivationVC = Controller.motivationSelection()
                                                        self.view?.router?.push(selectMotivationVC)
        })
        
        view?.configureMotivationView(model: motivationViewModel)
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
