//
//  Controllers.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 01/09/2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import UIKit

enum Controller {
    static func main() -> UIViewController {
        let vc = MainViewController.fromStoryboard(.main)
        let presenter = MainPresenter(view: vc)
        vc.presenter = presenter

        return vc
    }

    static func alert(_ message: String) -> UIViewController {
        let vc = AlertViewController.fromStoryboard(.alert)
        let presenter = AlertPresenter(view: vc, message: message)
        vc.presenter = presenter

        return vc
    }

    static func guide() -> UIViewController {
        let vc = GuideViewController.fromStoryboard(.guide)
        vc.modalPresentationStyle = .fullScreen
        let presenter = GuidePresenter(view: vc)
        vc.presenter = presenter

        return vc
    }

    static func createChallenge() -> UIViewController {
        let vc = CreateChallengeViewController.fromStoryboard(.createChallenge)
        let challengeRepository = ChallengeRepository()
        let purchaseManager = PurchasesManager()
        let challengeManager = ChallengeManager(challengeRepository: challengeRepository)
        let presenter = CreateChallengePresenter(view: vc, challengeManager: challengeManager, purchaseManager: purchaseManager)
        vc.presenter = presenter

        return vc
    }
    
    static func createSettings() -> UIViewController {
        let vc = SettingsViewController.fromStoryboard(.settings)
        let presenter = SettingsPresenter(view: vc)
        vc.presenter = presenter

        return vc
    }
    
    static func createMusicSelect() -> MusicSelectViewController {
        let vc = MusicSelectViewController.fromStoryboard(.settings)
        vc.presenter = MusicSelectPresenter(view: vc)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        
        return vc
    }
    
    static func currentChallenge(with challengeModel: Challenge, didTapGiveUp: @escaping () -> Void) -> UIViewController {
        let vc = CurrentChallengeViewController.fromStoryboard(.currentChallenge)
        let presenter = CurrentChallengePresenter(view: vc, challenge: challengeModel, didTapGiveUp: didTapGiveUp)
        vc.modalPresentationStyle = .fullScreen
        vc.presenter = presenter
        
        return vc
    }
    
    static func createPageNavigation() -> UIViewController {
        let challengeRepository = ChallengeRepository()
        let vc = PageNavigationViewController.fromStoryboard(.pageNavigation)
        vc.controllers = [createHistory(), createChallenge(), createSettings()]
    
        let presenter = PageNavigationPresenter(view: vc, challengeRepository: challengeRepository)

        vc.presenter = presenter

        return vc
    }

    static func createHistory() -> UIViewController {
        let vc = HistoryViewController.fromStoryboard(.history)

        return vc
    }

    static func createLosing(withFailedChallenge challenge: Challenge) -> UIViewController {
        let purchasesManager = PurchasesManager()
        let vc = LosingViewController.fromStoryboard(.losing)
        vc.modalPresentationStyle = .fullScreen
        let presenter = LosingPresenter(view: vc, failedChallenge: challenge, purchasesManager: purchasesManager)
        vc.presenter = presenter

        return vc
    }
}
