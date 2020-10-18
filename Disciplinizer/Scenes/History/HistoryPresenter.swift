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
    private var sortedDates: [Date] {
        Array(challenges.keys).sorted(by: >)
    }

    var numberOfDates: Int {
        challenges.keys.count
    }

    func numberOfChallengesForDate(section: Int) -> Int {
        let sortedKeys = sortedDates
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
        view?.set(viewTitle: Strings.historyTitle())
        view?.set(todayScoreTitle: Strings.historyToday(),
                  bestScoreTitle: Strings.historyBestScore())
        view?.set(clearButtonTitle: Strings.historyClear())
        view?.configure(noHistoryMessage: Strings.historyNoHistory())
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
        self.showTotalTodayResult(challenges: challenges.filter { Calendar.current.isDateInToday($0.key) }.flatMap { $0.value }.filter { $0.isSuccess })
        self.showBestDayResult(challengesByDates: Array(challenges.values))
    }
    
    private func showTotalTodayResult(challenges: [Challenge]) {
        let todayTotalDuration = challenges.reduce(0) { (result, challenge) -> Int in
            guard let finishDate = challenge.finishDate else { return result }
            
            return Calendar.current.isDateInToday(finishDate) ? result + challenge.durationInMinutes : result
        }
        
        self.view?.display(todayTotalDuration: Strings.durationInMinutes(minutes: todayTotalDuration))
    }
    
    private func showBestDayResult(challengesByDates: [[Challenge]]) {
        var bestResult = 0
        
        for challenges in challengesByDates {
            let bestForDay = challenges.filter { $0.isSuccess }.reduce(0, { $0 + $1.durationInMinutes })
            bestResult = max(bestResult, bestForDay)
        }
        
        view?.display(bestTotalDuraion: Strings.durationInMinutes(minutes: bestResult))
    }

    func clearButtonTapped() {
        guard !challenges.isEmpty else { return }
        
        let alertModel = AlertModel(title: Strings.historyAlertTitle(),
                                    message: Strings.historyAlertDescription(),
                                    positiveActionTitle: Strings.historyAlertCancel(),
                                    negativeActionTitle: Strings.historyAlertClear())
        
        let alert = Controller.createAlert(alertModel: alertModel,
                                           didTapNegative: {
            self.deleteChallengesUseCase.deleteAll { [weak self] (result) in
                    switch result {
                    case .success:
                        self?.challenges.removeAll()
                        self?.refreshBestResultsView()
                        self?.view?.refresh()
                        return
                    case .failure:
                        //self?.view?.showError(errorMessage: error.localizedDescription)
                        assertionFailure()
                        return
                    }
                }
        })
        view?.router?.present(alert)
    }
    
    func didTapDelete(forRow row: Int, inSection section: Int) {
        let sortedKeys = sortedDates
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
        let sortedKeys = sortedDates
        let date = sortedKeys[section]
        guard let challenges = challenges[date], challenges.count > row else {
            assertionFailure()
            return
        }

        let challenge = challenges[row]

        cell.display(result: challenge.isSuccess ? Strings.historySuccess() : Strings.historyFailed())
        cell.setResultTextColor(color: challenge.isSuccess ? R.color.greenText()! : R.color.redText()!)
        cell.display(duration: Strings.durationInMinutes(minutes: challenge.durationInMinutes))
        cell.display(motivationType: challenge.motivationalItem == .ad ? Strings.historyMotivationAd() : Strings.historyMotivationCat())
        
        if let startDate = challenge.startDate, let finishDate = challenge.finishDate {
            cell.display(timePeriod: getTimePerion(startDate: startDate, finishDate: finishDate))
        }
    }
    
    func configure(header: HistoryHeaderView, forSection section: Int) {
        let sortedKeys = sortedDates
        let date = sortedKeys[section]
        
        let totalResultForDate = challenges[date]?.filter { $0.isSuccess }.reduce(0, { $0 + $1.durationInMinutes }) ?? 0
        
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
        let sortedKeys = sortedDates
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
        let calendar = Calendar.current
        
        outerLoop: for challenge in challenges {
            guard let startDate = challenge.startDate else {
                assertionFailure()
                continue
            }
            
            for (date, _) in dict {
                if calendar.isDate(date, inSameDayAs: startDate) {
                    dict[date, default: []].insert(challenge, at: 0)
                    continue outerLoop
                }
            }

            dict[startDate, default: []].insert(challenge, at: 0)
        }

        return dict
    }
}
