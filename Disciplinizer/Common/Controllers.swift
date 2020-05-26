//
//  Controllers.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 01/09/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

enum Controller {
    static func createNavigaionVC(withRoot rootVC: UIViewController) -> UINavigationController {
        let vc = UINavigationController(rootViewController: rootVC)
        return vc
    }

    static func createPageNavigation() -> UIViewController {
        let vc = PageNavigationViewController.fromStoryboard(.pageNavigation)
        let viewControllers = [createHistory(), createChallenge(), createSettings()]
        var wrappedVCs: [UINavigationController] = []

        for vc in viewControllers {
            let navVC = createNavigaionVC(withRoot: vc)
            wrappedVCs.append(navVC)
        }

        vc.controllers = wrappedVCs

        return vc
    }

    static func createHistory() -> UIViewController {
        let vc = HistoryViewController.fromStoryboard(.history)

        return vc
    }

    static func createChallenge() -> UIViewController {
        let vc = CreateChallengeViewController.fromStoryboard(.createChallenge)
        vc.definesPresentationContext = true

        return vc
    }

    static func createSettings() -> UIViewController {
        let vc = SettingsViewController.fromStoryboard(.settings)

        return vc
    }

    static func motivationSelection() -> UIViewController {
        let vc = MotivatonSelectionViewController.fromStoryboard(.motivationSelection)

        return vc
    }
    
    static func createCatStore() -> UIViewController {
        let vc = CatStoreViewController.fromStoryboard(.catStore)
        vc.modalPresentationStyle = .currentContext

        return vc
    }

    static func timeSelection(routerDelegate: RouterDelegateProtocol? = nil) -> UIViewController {
        let vc = TimeSelectionViewController.fromStoryboard(.timeSelection)
        let configurator = TimeSelectionConfigurator(routerDelegate: routerDelegate)
        
        vc.configurator = configurator

        return vc
    }

    static func alert(model: AlertModel) -> UIViewController {
        let vc = AlertViewController.fromStoryboard(.alert)
        let configurator = AlertConfigurator(model: model)
        vc.configurator = configurator

        return vc
    }
    
    static func loading() -> UIViewController {
        let vc = LoadingViewController.fromStoryboard(.loading)

        return vc
    }

    static func guide() -> UIViewController {
        let vc = GuideViewController.fromStoryboard(.guide)
        vc.modalPresentationStyle = .currentContext
        let presenter = GuidePresenter(view: vc)
        vc.presenter = presenter

        return vc
    }
    
    static func guideChat() -> UIViewController {
        let vc = GuideChatViewController.fromStoryboard(.guideChat)
        vc.modalPresentationStyle = .fullScreen

        let presenter = GuideChatPresenter(view: vc)
        vc.presenter = presenter

        return vc
    }

    static func modeSelection(routerDelegate: RouterDelegateProtocol?) -> UIViewController {
        let vc = ModeSelectionViewController.fromStoryboard(.guide)
        let configurator = ModeSelectoinConfigurator(routerDelegate: routerDelegate)

        vc.configurator = configurator
        
        return vc
    }

    static func createMusicSelect() -> MusicSelectViewController {
        let vc = MusicSelectViewController.fromStoryboard(.musicSelection)
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

    static func createLosing(withFailedChallenge challenge: Challenge) -> UIViewController {
        let vc = BlockedViewController.fromStoryboard(.blocked)
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .currentContext
        
        let configurator = BlockedStateConfigurator(challenge: challenge)
        vc.configurator = configurator

        return vc
    }

    static func createAdVC() -> UIViewController {
        let vc = AdViewController.fromStoryboard(.ad)
        vc.modalPresentationStyle = .overCurrentContext

        return vc
    }
}
