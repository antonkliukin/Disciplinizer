//
//  MotivationSelectionPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol TimeSelectionPresenterProtocol {
    func viewDidLoad()
    func didEnter(_ input: String)
    func didTapSaveButton()
}

enum TimeSelectionViewState {
    case onHold, valid, invalid
}

class TimeSelectionPresenter: TimeSelectionPresenterProtocol {
    weak var view: TimeSelectionViewProtocol?
    
    private var durationParameterUseCase: DurationParameterUseCaseProtocol
    
    private var isEnteredTimeValid = false
    private var enteredDurationInMinutes = 0
    
    private weak var routerDelegate: RouterDelegateProtocol?

    init(view: TimeSelectionViewProtocol,
         routerDelegate: RouterDelegateProtocol?,
         durationParameterUseCase: DurationParameterUseCaseProtocol) {
        self.view = view
        self.routerDelegate = routerDelegate
        self.durationParameterUseCase = durationParameterUseCase
    }
    
    func viewDidLoad() {
        changeViewState(.onHold)
    }
    
    func changeViewState(_ state: TimeSelectionViewState) {
        switch state {
        case .onHold:
            view?.hideErrorMessage()
            view?.changeSaveButtonState(isEnabled: false)
            isEnteredTimeValid = false
        case .invalid:
            view?.showErrorMessage(Strings.timeSelectionErrorMessage())
            view?.changeSaveButtonState(isEnabled: false)
            isEnteredTimeValid = false
        case .valid:
            view?.hideErrorMessage()
            view?.changeSaveButtonState(isEnabled: true)
            isEnteredTimeValid = true
        }
    }
    
    func didEnter(_ input: String) {
        var input = input
        if input.isEmpty {
            input = "0"
        }
        
        guard let timeInMinutes = Int(input) else {
            
            changeViewState(.invalid)
            
            return
        }
        
        guard input.count > 1 else {
            changeViewState(.onHold)

            return
        }
        
        if input.count == 2, Int(input) ?? 0 <= 12 {
            changeViewState(.onHold)
            
            return
        }
        
        let isInputValid = isValid(enteredTime: timeInMinutes)
        
        if isInputValid {
            changeViewState(.valid)
            enteredDurationInMinutes = timeInMinutes
        } else {
            changeViewState(.invalid)
        }
    }
    
    func didTapSaveButton() {
        if isEnteredTimeValid {
            durationParameterUseCase.select(durationInMinutes: Int(enteredDurationInMinutes)) { (durationSavingResult) in
                switch durationSavingResult {
                case .success:
                    if let router = self.routerDelegate {
                        router.didTapNext()
                    } else {
                        self.view?.router?.pop()
                    }
                case .failure:
                    assertionFailure()
                }
            }
        } else {
            changeViewState(.invalid)
        }
    }
    
    private func isValid(enteredTime minutes: Int) -> Bool {
        (15...120).contains(minutes)
    }
}
