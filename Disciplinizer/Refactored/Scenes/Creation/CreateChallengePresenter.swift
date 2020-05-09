//
//  CreateChallengePresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 09/10/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol CreateChallengePresenterProtocol {
    func viewWillAppear()
    func startButtonTapped()
}

final class CreateChallengePresenter: CreateChallengePresenterProtocol {
    private weak var view: CreateChallengeViewProtocol?
    private let createChallengeUseCase: CreateChallengeUseCaseProtocol
    private let motivationParameterUseCase: MotivationParameterUseCaseProtocol
    private let durationParameterUseCase: DurationParameterUseCaseProtocol

    private var newChallenge: Challenge!
    private var selectedDurationInMinutes = 0

    init(view: CreateChallengeViewProtocol,
         createChallengeUseCase: CreateChallengeUseCaseProtocol,
         motivationalItemUseCase: MotivationParameterUseCaseProtocol,
         durationParameterUseCase: DurationParameterUseCaseProtocol) {
        self.view = view
        self.createChallengeUseCase = createChallengeUseCase
        self.motivationParameterUseCase = motivationalItemUseCase
        self.durationParameterUseCase = durationParameterUseCase
    }

    func viewWillAppear() {
        configureTimeView()
        configureMotivationView()
        
        view?.changeStartButtonState(isActive: true)
    }

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
            
            let challengeParameters = ChallengeParameters(startDate: Date(),
                                                          finishDate: nil,
                                                          durationInMinutes: self.selectedDurationInMinutes,
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
