//
//  HistoryPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 01.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol HistoryPresenterProtocol {
    var numberOfDates: Int { get }

    func numberOfChallengesForDate(section: Int) -> Int
    func titleForDate(section: Int) -> String
    func configure(cell: HistoryChallengeCellViewProtocol, forRow row: Int, inSection section: Int)
    func viewWillAppear()
    func clearButtonTapped()
}

final class HistoryPresenter: HistoryPresenterProtocol {
    private weak var view: HistoryViewProtocol?
    private let displayChallengesUseCase: DisplayChallengesUseCaseProtocol
    private let deleteChallengesUseCase: DeleteChallengeUseCaseProtocol

    private var challenges: [String: [Challenge]] = [:] {
        didSet {
            view?.refresh()
        }
    }

    var numberOfDates: Int {
        challenges.keys.count
    }

    func numberOfChallengesForDate(section: Int) -> Int {
        let sortedKeys = Array(challenges.keys).sorted(by: <)
        let key = sortedKeys[section]

        return challenges[key]?.count ?? 0
    }

    func titleForDate(section: Int) -> String {
        let sortedKeys = Array(challenges.keys).sorted(by: <)
        let date = sortedKeys[section]

        return date
    }

    init(view: HistoryViewProtocol,
         displayChallengesUseCase: DisplayChallengesUseCaseProtocol,
         deleteChallengesUseCase: DeleteChallengeUseCaseProtocol) {
        self.view = view
        self.displayChallengesUseCase = displayChallengesUseCase
        self.deleteChallengesUseCase = deleteChallengesUseCase
    }

    private func presentChallenges() {
        displayChallengesUseCase.displayChallenges { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let challenges):
                self.challenges = self.createDateChallengeDict(challenges: challenges)
            case .failure(let error):
                self.view?.showError(errorMessage: error.localizedDescription)
            }
        }
    }

    func viewWillAppear() {
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

    func configure(cell: HistoryChallengeCellViewProtocol, forRow row: Int, inSection section: Int) {
        let sortedKeys = Array(challenges.keys).sorted(by: <)
        let date = sortedKeys[section]
        guard let challenges = challenges[date], challenges.count > row else {
            assertionFailure()
            return
        }

        let challenge = challenges[row]

        cell.display(result: challenge.isSuccess ? "Success" : "Loose")
        cell.display(duration: "Duration: \(challenge.duration / 60) mins")
        // cell.display(motivationType: "Motivation: \(challenge.isPaid ? "Golden Coin" : "Watching Ad")")
    }

    private func createDateChallengeDict(challenges: [Challenge]) -> [String: [Challenge]] {
        var dict: [String: [Challenge]] = [:]

        for challenge in challenges {
            guard let date = challenge.startDate else {
                assertionFailure()
                continue
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let stringDate = formatter.string(from: date)

            dict[stringDate, default: []].append(challenge)
        }

        return dict
    }
}
