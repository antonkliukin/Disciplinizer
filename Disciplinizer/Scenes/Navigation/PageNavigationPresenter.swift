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
        //
    }

    required init(view: PageNavigationViewProtocol,
                  motivationParameterUseCase: MotivationParameterUseCaseProtocol) {
        self.view = view
        self.motivationParameterUseCase = motivationParameterUseCase
    }
}
