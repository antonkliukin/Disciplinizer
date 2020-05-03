//
//  CatStorePresenter.swift
//  Disciplinizer
//
//  Created by Anton on 01.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol CatStorePresenterProtocol {
    func viewDidLoad()
}

class CatStorePresenter: CatStorePresenterProtocol {
    weak var view: CatStoreViewProtocol?
    
    private var items: [MotivationalItem] {
        MotivationalItem.allCats
    }
    
    init(view: CatStoreViewProtocol) {
        self.view = view
    }
        
    func viewDidLoad() {
        view?.showMotivationItems(items)
    }
}
