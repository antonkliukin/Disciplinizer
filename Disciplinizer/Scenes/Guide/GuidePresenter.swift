//
//  GuidePresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 12/09/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol GuidePresenterProtocol: class {
    func didTapNext()
    func viewDidAppear()
}

class GuidePresenter: GuidePresenterProtocol {
    weak var view: GuideViewProtocol?
    
    private var currentIndex = 0

    init(view: GuideViewProtocol) {
        self.view = view
    }
    
    func viewDidAppear() {
        view?.updateProgressBar(progress: 0.33, completion: nil)
    }
    
    func didTapNext() {
        if currentIndex == 1 {
            view?.updateProgressBar(progress: 1) {
                self.view?.router?.dismiss(animated: true, completion: nil, toRoot: true)
            }
        } else {
            view?.updateProgressBar(progress: 0.66, completion: nil)
            currentIndex += 1
        }
    }
}
