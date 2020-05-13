//
//  PageNavigationPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 17.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol PageNavigationPresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
}

final class PageNavigationPresenter: PageNavigationPresenterProtocol {
    weak var view: PageNavigationViewProtocol?
    
    private let motivationParameterUseCase: MotivationParameterUseCaseProtocol
    
    func viewDidLoad() {
        //
    }
    
    func viewWillAppear() {
        //
    }
        
    func viewDidAppear() {
        checkIfFirstLaunch()
        checkIfShowGuide()
    }

    required init(view: PageNavigationViewProtocol,
                  motivationParameterUseCase: MotivationParameterUseCaseProtocol) {
        self.view = view
        self.motivationParameterUseCase = motivationParameterUseCase
    }
            
    private func checkIfFirstLaunch() {
        AppLockManager.shared.checkIfFirstLaunch { (isFirstLaunch) in
            if isFirstLaunch, KeychainService.isFirstLaunch {
                KeychainService.isFirstLaunch = false
                
                AppLockManager.shared.changeStateTo(.unlocked)
                KeychainService.appLockState = .unlocked
                
                self.addPaidItem()
            }
        }
    }
    
    private func addPaidItem() {
        let paid = MotivationalItem.level1
        motivationParameterUseCase.addPaid(motivationalItem: paid) { (_) in }
    }
    
    private func checkIfShowGuide() {
        let isFirstLaunchEntry = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if isFirstLaunchEntry == false {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            self.view?.router?.present(Controller.guideChat(), animated: false, forcePresent: false, completion: nil)
        }
    }
}
