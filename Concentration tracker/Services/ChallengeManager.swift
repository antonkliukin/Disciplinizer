//
//  ChallengeService.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 26.10.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import UIKit

var isChallengeRunning = false

enum ChallengeManagerError: Error {
    case startError
    case notificationsNotAuthorized
    case storageError

    var localizedDescription: String {
        switch self {
        case .startError: return "startError"
        case .notificationsNotAuthorized: return "notificationsNotAuthorized"
        case .storageError: return "storageError"
        }
    }
}

final class ChallengeManager {
    private let challengeRepository: ChallengeStorageProtocol
    private var activeChallenge: Challenge? {
        willSet {
            isChallengeRunning = newValue != nil
        }
    }

    private var winTimer: Timer?
    private var loseTimer: Timer?
    private var onFinish: ((ChallengeResult) -> Void)?
    private var willResignActiveDate: Date?

    private var notifCenter = NotificationCenter.default

    var isDeviceLocked: Bool {
        return UIScreen.main.brightness == 0.0
    }

    init(challengeRepository: ChallengeStorageProtocol) {
        self.challengeRepository = challengeRepository
        addAppDelegateObservers()
    }

    private func addAppDelegateObservers() {
        notifCenter.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notifCenter.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        notifCenter.addObserver(self, selector: #selector(willTerminate), name: UIApplication.willTerminateNotification, object: nil)
        notifCenter.addObserver(self, selector: #selector(willResingActive), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc private func didEnterBackground() {
        guard isChallengeRunning, let willResignActiveDate = willResignActiveDate else { return }

        // TODO: Legal BG check - Version 2
        let timeSinceResign = Date().timeIntervalSince(willResignActiveDate)
        let wasPowerPressed = timeSinceResign < 0.1

        if wasPowerPressed {
            print("Background is legal")
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                NotificationManager.sendReturnToAppNotification()
                self.fireLoseTimer(withInterval: 10)
                print("Background is NOT legal. Lose timer has been started.")
            }
        }

        // TODO: Legal BG check - Version 1
//        isBackgroundLegal { (isLegal) in
//            if isLegal {
//                print("Background is legal")
//            } else {
//                self.fireLoseTimer(withInterval: 10)
//                print("Background is NOT legal. Lose timer has been started.")
//            }
//        }
    }

    @objc private func didBecomeActive() {
        loseTimer?.invalidate()
    }

    @objc private func willTerminate() {
        finishCurrentWith(result: .lose)
    }

    @objc private func willResingActive() {
        willResignActiveDate = Date()
    }

    private func isBackgroundLegal(handler: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if !self.isDeviceLocked {
                NotificationManager.sendReturnToAppNotification()
                handler(false)
            } else {
                print("Device was locked")
                handler(true)
            }
        }
    }

    private func fireLoseTimer(withInterval interval: TimeInterval) {
        self.loseTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { [weak self] (_) in
            self?.finishCurrentWith(result: .lose)
        })
    }

    private func fireWinTimer(withInterval interval: TimeInterval) {
        winTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { [weak self] (_) in
            self?.finishCurrentWith(result: .win)
        })
    }

    func start(_ challenge: Challenge,
               onFinish: @escaping (ChallengeResult) -> Void) -> Result<Challenge, ChallengeManagerError> {
        guard !isChallengeRunning else { return .failure(.startError) }

        let isNotifEnabled = NotificationManager.shared.isAuthorized()

        guard isNotifEnabled else {
            return .failure(ChallengeManagerError.notificationsNotAuthorized)
        }

        self.onFinish = onFinish
        
        let savingResult = challengeRepository.save(challenge)

        switch savingResult {
        case .failure:
            return .failure(.startError)
        case .success:
            activeChallenge = challenge

            fireWinTimer(withInterval: challenge.duration)

            return .success(challenge)
        }
    }

    func finishCurrentWith(result: ChallengeResult) {
        guard let current = self.activeChallenge else {
            return
        }

        guard current.finishDate == nil else {
            print("Challenge with id \(current.id) has already been finished")
            return
        }

        _ = self.challengeRepository.update {
            self.activeChallenge?.isSuccess = result == .win
            self.activeChallenge?.finishDate = Date()

            print("\(result == .win ? "Succeeded" : "Failed") in challenge with id \(current.id)")

            self.activeChallenge = nil
        }

        self.onFinish?(result)
    }
}
