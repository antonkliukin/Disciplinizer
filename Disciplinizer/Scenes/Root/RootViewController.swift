//
//  RootViewController.swift
//  Disciplinizer
//
//  Created by Anton on 14.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

var rootVC = RootViewController()

class RootViewController: UIViewController, ViewProtocol {
    private var stubView = LaunchScreenView()
    private var isReady = false
    
    func dismiss(animated flag: Bool, allPresented: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: {
            completion?()
            
            if allPresented {
                if let childVC = self.children.first as? PageNavigationViewController {
                    for vc in childVC.viewControllers ?? [] {
                        vc.dismiss(animated: flag, completion: nil)
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootVC.add(Controller.createPageNavigation())
        
        stubView.backgroundColor = .white
        stubView.frame = view.frame
        view.addSubview(stubView)
        
        prepareForUse()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        if isReady {
            checkIfFirstLaunch()
        }
    }
    
    private func prepareForUse() {
        PurchasesManager.shared.getAvailiableBets { (_) in return }

        let challengeParametersGateway = ChallengeParametersPersistenceGateway()
        let motivationParameterUseCase = MotivationParameterUseCase(challengesParametersGateway: challengeParametersGateway)
                        
        AppLockManager.shared.checkIfFirstLaunch { (isFirstLaunch) in
            if isFirstLaunch, KeychainService.isFirstLaunch {
                KeychainService.isFirstLaunch = false
                
                AppLockManager.shared.changeStateTo(.unlocked)
                KeychainService.appLockState = .unlocked
                
                let paid = MotivationalItem.level5
                motivationParameterUseCase.addPaid(motivationalItem: paid) { (_) in }
                motivationParameterUseCase.select(motivationalItem: paid) { (_) in }
            }
            
            self.isReady = true
            self.checkIfFirstLaunch()
        }
    }
    
    private func checkIfFirstLaunch() {
        let isFirstLaunchStampExist = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunchStampExist == false {
            router?.present(Controller.guideChat(), animated: false, forcePresent: false, completion: {
                self.stubView.removeFromSuperview()
            })
        } else {
            self.stubView.removeFromSuperview()
        }
    }
}
