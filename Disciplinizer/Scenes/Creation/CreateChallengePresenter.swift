//
//  CreateChallengePresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 09/10/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol CreateChallengePresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func startButtonTapped()
}

final class CreateChallengePresenter: CreateChallengePresenterProtocol {
    private weak var view: CreateChallengeViewProtocol?
    private let createChallengeUseCase: CreateChallengeUseCaseProtocol
    private let motivationParameterUseCase: MotivationParameterUseCaseProtocol
    private let durationParameterUseCase: DurationParameterUseCaseProtocol
    private let getLastChallengeUseCase: DisplayLastChallengeUseCaseProtocol

    private var newChallenge: Challenge!
    private var selectedDurationInMinutes = 0

    init(view: CreateChallengeViewProtocol,
         createChallengeUseCase: CreateChallengeUseCaseProtocol,
         motivationalItemUseCase: MotivationParameterUseCaseProtocol,
         durationParameterUseCase: DurationParameterUseCaseProtocol,
         getLastChallengeUseCase: DisplayLastChallengeUseCaseProtocol) {
        self.view = view
        self.createChallengeUseCase = createChallengeUseCase
        self.motivationParameterUseCase = motivationalItemUseCase
        self.durationParameterUseCase = durationParameterUseCase
        self.getLastChallengeUseCase = getLastChallengeUseCase
    }
    
    func viewDidLoad() {
        view?.set(viewTitle: Strings.creationTitle())
        view?.set(startButtonTitle: Strings.creationStartButtonTitle())
    }

    func viewWillAppear() {
        checkIfLocked()

        configureTimeView()
        configureMotivationView()
        
        view?.changeStartButtonState(isActive: true)
    }
    
    private func checkIfLocked() {
        AppLockManager.shared.getCurrentState { (state) in
            switch state {
            case .locked:
                self.showBlockedView()
            case .unlocked:
                if KeychainService.appLockState == .locked {
                    self.showBlockedView()
                }
            }
        }
    }
    
    private func showBlockedView() {
        self.getLastChallengeUseCase.displayLastChallenge(completionHandler: { (lastChallengeGettingResult) in
            switch lastChallengeGettingResult {
            case .success(let lastChallenge):
                guard let challenge = lastChallenge, !challenge.isSuccess else {
                    assertionFailure()
                    return
                }

                let losingVC = Controller.createLosing(withFailedChallenge: challenge)
                self.view?.router?.present(losingVC, animated: false, forcePresent: true, completion: nil)
            case .failure:
                assertionFailure()
                return
            }

        })
    }

    func startButtonTapped() {
        let isNotifEnabled = NotificationManager.shared.isAuthorized()

        guard isNotifEnabled else {
            let alertModel = AlertModel(title: Strings.creationAlertNotificationsTitle(),
                                        message: Strings.creationAlertNotificationsDescription(),
                                        positiveActionTitle: Strings.creationAlertNotificationsPositive(),
                                        positiveAction: { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) },
                                        negativeActionTitle: Strings.creationAlertNotificationsNegative(),
                                        negativeAction: nil)
            view?.router?.present(Controller.alert(model: alertModel))
            
            return
        }

        view?.changeStartButtonState(isActive: false)

        createChallenge()
    }
    
    private func configureTimeView() {
        durationParameterUseCase.getSelectedDurationInMinutes { (selectedDurationResult) in
            switch selectedDurationResult {
            case .success(let durationInMinutes):
                self.selectedDurationInMinutes = durationInMinutes
                
                let timeViewModel = ParameterViewModel(title: Strings.creationTimeTitle(),
                                                       valueTitle: Strings.durationInMinutes(minutes: durationInMinutes),
                                                       actionTitle: Strings.creationActionTitle(),
                                                       action: {
                                                        let selectTimeVC = Controller.timeSelection()
                                                        self.view?.router?.push(selectTimeVC)
                })
                
                self.view?.configureTimeView(model: timeViewModel)
            case .failure:
                self.selectedDurationInMinutes = 30
                
                let timeViewModel = ParameterViewModel(title: Strings.creationTimeTitle(),
                                                       valueTitle: Strings.durationInMinutes(minutes: 30),
                                                       actionTitle: Strings.creationActionTitle(),
                                                       action: {
                                                        let selectTimeVC = Controller.timeSelection()
                                                        self.view?.router?.push(selectTimeVC)
                })
                
                self.view?.configureTimeView(model: timeViewModel)
            }
        }
    }
    
    private func configureMotivationView() {
        motivationParameterUseCase.getSelectedMotivationalItem { (result) in
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
                let item = MotivationalItem.ad
                self.motivationParameterUseCase.select(motivationalItem: item) { (result) in
                    switch result {
                    case .success:
                        self.configureMotivationView()
                    case .failure:
                        assertionFailure()
                    }
                }
            }
        }
    }
    
    private func createChallenge() {
        
        motivationParameterUseCase.getSelectedMotivationalItem { (result) in
            guard let item = try? result.get() else {
                assertionFailure()
                return
            }
            // TODO: delete test duration
            let challengeParameters = ChallengeParameters(startDate: Date(),
                                                          finishDate: nil,
                                                          durationInMinutes: 1,//self.selectedDurationInMinutes,
                                                          isSuccess: false,
                                                          motivationalItem: item)

            self.createChallengeUseCase.createWith(parameters: challengeParameters) { [weak self] (creationResult) in
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
}
