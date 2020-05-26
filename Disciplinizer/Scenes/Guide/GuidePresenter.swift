//
//  GuidePresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 12/09/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol GuidePresenterProtocol: class {
    func didTapNext()
    func viewDidLoad()
    func viewDidAppear()
}

class GuidePresenter: GuidePresenterProtocol {
    weak var view: GuideViewProtocol?
    
    private var currentIndex = 0

    init(view: GuideViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.updateProgressBar(progress: 0.33, animated: false, completion: nil)
    }
    
    func viewDidAppear() {
        
    }
    
    func didTapNext() {
        if currentIndex == 1 {
            view?.updateProgressBar(progress: 1, animated: true) {
                UserDefaults.standard.set(true, forKey: "isFirstLaunch")

                self.view?.router?.dismissPresenting(animated: true, completion: {
                    NotificationManager.shared.requestAuthorization()
                })
            }
        } else {
            view?.updateProgressBar(progress: 0.66, animated: true, completion: nil)
            currentIndex += 1
        }
    }
}
