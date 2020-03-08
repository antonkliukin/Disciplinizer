//
//  Controllers.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 01/09/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

enum Controller {
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
    
    static func currentChallenge(with challengeModel: Challenge) -> UIViewController {
        let vc = CurrentChallengeViewController.fromStoryboard(.currentChallenge)
        let configurator = CurrentChallengeConfigurator(challenge: challengeModel)
        vc.configurator = configurator
        vc.modalPresentationStyle = .fullScreen
        
        return vc
    }
    
    static func createPageNavigation() -> UIViewController {
        let vc = PageNavigationViewController.fromStoryboard(.pageNavigation)
        vc.controllers = [createHistory(), createChallenge(), createSettings()]

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
