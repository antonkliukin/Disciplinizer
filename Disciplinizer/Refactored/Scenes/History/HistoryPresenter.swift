//
//  HistoryPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 01.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol HistoryPresenterProtocol {
    func viewDidLoad()
    func viewDidAppear()
    func clearButtonTapped()
}

final class HistoryPresenter: HistoryPresenterProtocol {
    private weak var view: HistoryViewProtocol?
    private let displayChallengesUseCase: DisplayChallengesUseCaseProtocol
    private let deleteChallengesUseCase: DeleteChallengeUseCaseProtocol

    init(view: HistoryViewProtocol,
         displayChallengesUseCase: DisplayChallengesUseCaseProtocol,
         deleteChallengesUseCase: DeleteChallengeUseCaseProtocol) {
        self.view = view
        self.displayChallengesUseCase = displayChallengesUseCase
        self.deleteChallengesUseCase = deleteChallengesUseCase
    }

    private func presentChallenges() {
        displayChallengesUseCase.displayChallenges { [weak self] (result) in
            switch result {
            case .success(let challenges):
                self?.view?.show(challenges)
            case .failure(let error):
                self?.view?.showError(errorMessage: error.localizedDescription)
            }
        }
    }

    func viewDidLoad() {}

    func viewDidAppear() {
        presentChallenges()
    }

    func clearButtonTapped() {
        deleteChallengesUseCase.deleteAll { [weak self] (result) in
            switch result {
            case .success:
                self?.presentChallenges()
            case .failure(let error):
                self?.view?.showError(errorMessage: error.localizedDescription)
            }
        }
    }
}
