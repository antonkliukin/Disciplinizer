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
    func configure(cell: HistoryChallengeCellViewProtocol, forRow row: Int, inSection section: Int)
    func configure(header: HistoryHeaderView, forSection section: Int)
    func viewDidLoad()
    func viewWillAppear()
    func clearButtonTapped()
    func didTapDelete(forRow row: Int, inSection section: Int)}

final class HistoryPresenter: HistoryPresenterProtocol {
    private weak var view: HistoryViewProtocol?
    private let displayChallengesUseCase: DisplayChallengesUseCaseProtocol
    private let deleteChallengesUseCase: DeleteChallengeUseCaseProtocol

    private var challenges: [Date: [Challenge]] = [:]

    var numberOfDates: Int {
        challenges.keys.count
    }

    func numberOfChallengesForDate(section: Int) -> Int {
        let sortedKeys = Array(challenges.keys).sorted(by: <)
        let key = sortedKeys[section]

        return challenges[key]?.count ?? 0
    }

    init(view: HistoryViewProtocol,
         displayChallengesUseCase: DisplayChallengesUseCaseProtocol,
         deleteChallengesUseCase: DeleteChallengeUseCaseProtocol) {
        self.view = view
        self.displayChallengesUseCase = displayChallengesUseCase
        self.deleteChallengesUseCase = deleteChallengesUseCase
    }
    
    func viewDidLoad() {
        //loadChallenges()
    }

    func viewWillAppear() {
        loadChallenges()
    }
    
    private func loadChallenges() {
        displayChallengesUseCase.displayChallenges { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let challenges):
                
                let dateChallengeDict = self.createDateChallengeDict(challenges: challenges)
                self.challenges = dateChallengeDict
                self.refreshBestResultsView()
                
                self.view?.refresh()
            case .failure:
                //self.view?.showError(errorMessage: error.localizedDescription)
                assertionFailure()
                return
            }
        }
    }
    
    private func refreshBestResultsView() {
        self.showTotalTodayResult(challenges: challenges.filter { Calendar.current.isDateInToday($0.key) }.flatMap { $0.value })
        self.showBestDayResult(challengesByDates: Array(challenges.values))
    }
    
    private func showTotalTodayResult(challenges: [Challenge]) {
        let todayTotalDuration = challenges.reduce(0) { (result, challenge) -> Int in
            guard let finishDate = challenge.finishDate else { return result }
            
            return Calendar.current.isDateInToday(finishDate) ? result + challenge.duration : result
        }
        
        self.view?.display(todayTotalDuration: Strings.durationInMinutes(minutes: todayTotalDuration))
    }
    
    private func showBestDayResult(challengesByDates: [[Challenge]]) {
        var bestResult = 0
        
        for challenges in challengesByDates {
            let bestForDay = challenges.reduce(0, { $0 + $1.duration })
            bestResult = max(bestResult, bestForDay)
        }
        
        view?.display(bestTotalDuraion: Strings.durationInMinutes(minutes: bestResult))
    }

    func clearButtonTapped() {
        deleteChallengesUseCase.deleteAll { [weak self] (result) in
            switch result {
            case .success:
                self?.view?.refresh()
                return
            case .failure:
                //self?.view?.showError(errorMessage: error.localizedDescription)
                assertionFailure()
                return
            }
        }
    }
    
    func didTapDelete(forRow row: Int, inSection section: Int) {
        let sortedKeys = Array(challenges.keys).sorted(by: <)
        let date = sortedKeys[section]
        guard let challenges = challenges[date], challenges.count > row else {
            assertionFailure()
            return
        }
        
        self.challenges[date]?.remove(at: row)
        
        refreshBestResultsView()
        
        deleteChallengesUseCase.delete(challenge: challenges[row]) { (deletionResult) in
            switch deletionResult {
            case .success:
                return
            case .failure:
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
        cell.display(duration: Strings.durationInMinutes(minutes: challenge.duration))
        cell.display(motivationType: challenge.motivationalItem == .ad ? Strings.historyMotivationAd() : Strings.historyMotivationCat())
        
        if let startDate = challenge.startDate, let finishDate = challenge.finishDate {
            cell.display(timePeriod: getTimePerion(startDate: startDate, finishDate: finishDate))
        }
    }
    
    func configure(header: HistoryHeaderView, forSection section: Int) {
        let sortedKeys = Array(challenges.keys).sorted(by: <)
        let date = sortedKeys[section]
        
        let totalResultForDate = challenges[date]?.reduce(0, { $0 + $1.duration }) ?? 0
        
        let calendar = Calendar.current
        var dateString = ""
        
        if calendar.isDateInToday(date) {
            dateString = Strings.historyToday()
        } else if calendar.isDateInTomorrow(date) {
            dateString = Strings.historyYesterday()
        } else {
            dateString = titleForDate(section: section)
        }
        
        header.dateLabel.text = dateString
        header.todayDuration.text = Strings.historyConcentrationDuration(totalDurationForDay: totalResultForDate)
    }
    
    private func titleForDate(section: Int) -> String {
        let sortedKeys = Array(challenges.keys).sorted(by: <)
        let date = sortedKeys[section]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let stringDate = formatter.string(from: date)

        return stringDate
    }
    
    private func getTimePerion(startDate: Date, finishDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let start = formatter.string(from: startDate)
        let finish = formatter.string(from: finishDate)
        
        return start + "-" + finish
    }

    private func createDateChallengeDict(challenges: [Challenge]) -> [Date: [Challenge]] {
        var dict: [Date: [Challenge]] = [:]

        for challenge in challenges {
            guard let date = challenge.startDate else {
                assertionFailure()
                continue
            }

            dict[date, default: []].append(challenge)
        }

        return dict
    }
}
