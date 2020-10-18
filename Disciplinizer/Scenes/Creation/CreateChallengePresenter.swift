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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateMotivationView),
                                               name: Notification.Name.selectedMotivationalItemChanged,
                                               object: nil)
    }

    func viewWillAppear() {
        checkIfLocked()

        configureTimeView()
        updateMotivationView()
        
        view?.changeStartButtonState(isActive: true)
    }
        
    @objc private func updateMotivationView() {
        configureMotivationView()
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
                let stubChallenge = Challenge(id: UUID().uuidString,
                                              startDate: nil,
                                              finishDate: nil,
                                              durationInMinutes: 0,
                                              isSuccess: false,
                                              motivationalItem: .ad)
                
                let challenge = lastChallenge ?? stubChallenge
                
                guard !challenge.isSuccess else {
                    return
                }

                let losingVC = Controller.createLose(withFailedChallenge: challenge)
                self.view?.router?.present(losingVC, animated: true, forcePresent: false, completion: nil)
            case .failure:
                return
            }

        })
    }

    func startButtonTapped() {
        let isNotifEnabled = NotificationManager.shared.isAuthorized()

        guard isNotifEnabled else {
            showDisabledNotificationsAlert()
            
            return
        }

        createAndStartChallenge()
    }
    
    private func showDisabledNotificationsAlert() {
        let alertModel = AlertModel(title: Strings.creationAlertNotificationsTitle(),
                                    message: Strings.creationAlertNotificationsDescription(),
                                    positiveActionTitle: Strings.creationAlertNotificationsPositive(),
                                    negativeActionTitle: Strings.creationAlertNotificationsNegative())
        
        let alert = Controller.createAlert(alertModel: alertModel, didTapPositive: {
             UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }, didTapNegative: {
            self.createAndStartChallenge()
        })
        
        view?.router?.present(alert)
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
                let motivationViewModel = ParameterViewModel(title: Strings.creationMotivationTitle(),
                                                             valueImage: item.image,
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
    
    private func createAndStartChallenge() {
        
        motivationParameterUseCase.getSelectedMotivationalItem { (result) in
            guard let item = try? result.get() else {
                assertionFailure()
                return
            }
            
            let createAndStartBlock = {
                self.view?.changeStartButtonState(isActive: false)

                let duration = Config.shared.devDurationInMinutes() ?? self.selectedDurationInMinutes

                let challengeParameters = ChallengeParameters(startDate: Date(),
                                                              finishDate: nil,
                                                              durationInMinutes: duration,
                                                              isSuccess: false,
                                                              motivationalItem: item)

                self.createChallengeUseCase.createWith(parameters: challengeParameters) { [weak self] (creationResult) in
                    guard let self = self else {
                        assertionFailure()
                        return
                    }

                    switch creationResult {
                    case .success(let createdChallenge):
                        self.view?.router?.present(Controller.currentChallenge(with: createdChallenge),
                                                   animated: true,
                                                   forcePresent: false,
                                                   completion: nil)
                    case .failure:
                        assertionFailure()
                    }
                }
            }
            
            if !(item == .ad) {
                self.showPetModeAlert {
                    createAndStartBlock()
                }
            } else {
                createAndStartBlock()
            }
        }
    }
    
    private func showPetModeAlert(startChallengeAction: @escaping () -> Void) {
        let alertModel = AlertModel(title: Strings.creationAlertPetModeTitle(),
                                    message: Strings.creationAlertPetModeDescription(),
                                    positiveActionTitle: Strings.creationAlertPetModePositive(),
                                    negativeActionTitle: Strings.creationAlertPetModeNegative())
        
        let alert = Controller.createAlert(alertModel: alertModel, didTapNegative: {
             startChallengeAction()
        })
        
        view?.router?.present(alert)
    }
}
