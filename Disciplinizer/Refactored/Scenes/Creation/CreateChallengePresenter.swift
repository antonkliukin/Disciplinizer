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
    func viewWillAppear()
    func startButtonTapped()
    func didChooseMode(_ mode: ChallengeMode)
    func didSetTimer(withTimeInMinutes minutes: Int)
}

final class CreateChallengePresenter: CreateChallengePresenterProtocol {
    private weak var view: CreateChallengeViewProtocol?
    private let createChallengeUseCase: CreateChallengeUseCaseProtocol
    private let motivationItemUseCase: MotivationParameterUseCaseProtocol
    private let durationParameterUseCase: DurationParameterUseCaseProtocol

    private var newChallenge: Challenge!

    init(view: CreateChallengeViewProtocol,
         createChallengeUseCase: CreateChallengeUseCaseProtocol,
         motivationalItemUseCase: MotivationParameterUseCaseProtocol,
         durationParameterUseCase: DurationParameterUseCaseProtocol) {
        self.view = view
        self.createChallengeUseCase = createChallengeUseCase
        self.motivationItemUseCase = motivationalItemUseCase
        self.durationParameterUseCase = durationParameterUseCase
    }

    func viewDidLoad() {
//        configureTimeView()
//        configureMotivationView()
    }
    
    func viewWillAppear() {
        configureTimeView()
        configureMotivationView()
    }

    private var selectedDurationInMinutes = 0

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
        durationParameterUseCase.getSelectedDurationInMinutes { (selectedDurationResult) in
            switch selectedDurationResult {
            case .success(let durationInMinutes):
                self.selectedDurationInMinutes = durationInMinutes
                
                let timeViewModel = ParameterViewModel(title: Strings.creationTimeTitle(),
                                                       valueTitle: "\(durationInMinutes) min",
                                                       actionTitle: Strings.creationActionTitle(),
                                                       action: {
                                                        let selectTimeVC = Controller.timeSelection()
                                                        self.view?.router?.push(selectTimeVC)
                })
                
                self.view?.configureTimeView(model: timeViewModel)
            case .failure:
                self.selectedDurationInMinutes = 30 * 60
                
                let timeViewModel = ParameterViewModel(title: Strings.creationTimeTitle(),
                                                       valueTitle: "\(30) min",
                                                       actionTitle: Strings.creationActionTitle(),
                                                       action: {
                                                        let selectTimeVC = Controller.timeSelection()
                                                        self.view?.router?.push(selectTimeVC)
                })
                
                self.view?.configureTimeView(model: timeViewModel)
            }
        }
    }
    
    func configureMotivationView() {
        motivationItemUseCase.getSelectedMotivationalItem { (result) in
            switch result {
            case .success(let item):
                let title = item == .ad ? Strings.creationSaveTime() : Strings.creationSaveCat()
                let motivationViewModel = ParameterViewModel(title: Strings.creationMotivationTitle(),
                                                             valueTitle: title,
                                                             actionTitle: Strings.creationActionTitle(),
                                                             action: {
                                                                let selectMotivationVC = Controller.motivationSelection()
                                                                self.view?.router?.push(selectMotivationVC)
                })

                self.view?.configureMotivationView(model: motivationViewModel)
            case .failure:
                assertionFailure()
                                                                
            }
        }
    }

    private func createChallenge() {
        let isPaid = false
        let betId = "1"
        
        let challengeParameters = ChallengeParameters(startDate: Date(),
                                                      finishDate: nil,
                                                      durationInMinutes: selectedDurationInMinutes,
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
