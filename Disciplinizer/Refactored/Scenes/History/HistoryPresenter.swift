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

    func viewWillAppear() {
        presentChallenges()
    }
    
    private func presentChallenges() {
        displayChallengesUseCase.displayChallenges { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let challenges):
                
                let dateChallengeDict = self.createDateChallengeDict(challenges: challenges)
                self.challenges = dateChallengeDict
                self.showTotalTodayResult(challenges: challenges)
                self.showBestDayResult(challengesByDates: Array(dateChallengeDict.values))
            case .failure:
                //self.view?.showError(errorMessage: error.localizedDescription)
                assertionFailure()
                return
            }
        }
    }
    
    private func showTotalTodayResult(challenges: [Challenge]) {
        let todayTotalDuration = challenges.reduce(0) { (result, challenge) -> Int in
            guard let finishDate = challenge.finishDate else { return result }
            
            return Calendar.current.isDateInToday(finishDate) ? result + challenge.duration : result
        }
        
        self.view?.display(todayTotalDuration: String(todayTotalDuration))
    }
    
    private func showBestDayResult(challengesByDates: [[Challenge]]) {
        var bestResult = 0
        
        for challenges in challengesByDates {
            let bestForDay = challenges.reduce(0, { $0 + $1.duration })
            bestResult = max(bestResult, bestForDay)
        }
        
        view?.display(bestTotalDuraion: String(bestResult))
    }

    func clearButtonTapped() {
        deleteChallengesUseCase.deleteAll { [weak self] (result) in
            switch result {
            case .success:
                self?.presentChallenges()
            case .failure:
                //self?.view?.showError(errorMessage: error.localizedDescription)
                assertionFailure()
                return
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

        cell.display(result: challenge.isSuccess ? Strings.historySuccess() : Strings.historyFailed())
        cell.display(duration: "\(challenge.duration) min")
        cell.display(motivationType: challenge.motivationalItem == .ad ? Strings.historyMotivationAd() : Strings.historyMotivationCat())
        
        if let startDate = challenge.startDate, let finishDate = challenge.finishDate {
            cell.display(timePeriod: getTimePerion(startDate: startDate, finishDate: finishDate))
        }
    }
    
    private func getTimePerion(startDate: Date, finishDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let start = formatter.string(from: startDate)
        let finish = formatter.string(from: finishDate)
        
        return start + "-" + finish
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
