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

class TimeSelectionPresenter: TimeSelectionPresenterProtocol {
    weak var view: TimeSelectionViewProtocol?
    
    private var isEnteredTimeValid = false

    init(view: TimeSelectionViewProtocol) {
        self.view = view
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
        
        let isInputValid = isValid(enteredTime: timeInMinutes)
        
        changeViewState(isInputValid ? .valid : .invalid)
    }
    
    func didTapSaveButton() {
        if isEnteredTimeValid {
            view?.router?.pop()
        } else {
            view?.showErrorMessage(Strings.timeSelectionErrorMessage())
        }
    }
    
    private func isValid(enteredTime minutes: Int) -> Bool {
        (15...120).contains(minutes)
    }
}
