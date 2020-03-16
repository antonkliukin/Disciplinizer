//
//  MotivationSelectionPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol TimeSelectionPresenterProtocol {

}

class TimeSelectionPresenter: TimeSelectionPresenterProtocol {
    weak var view: TimeSelectionViewProtocol?

    init(view: TimeSelectionViewProtocol) {
        self.view = view
    }
}
