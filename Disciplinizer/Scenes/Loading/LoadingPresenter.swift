//
//  LoadingPresenter.swift
//  Disciplinizer
//
//  Created by Anton on 03.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol LoadingPresenterProtocol {

}

class LoadingPresenter: LoadingPresenterProtocol {
    weak var view: LoadingViewProtocol?
    
    init(view: LoadingViewProtocol) {
        self.view = view
    }
}
