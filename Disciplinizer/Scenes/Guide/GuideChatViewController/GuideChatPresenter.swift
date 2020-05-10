//
//  GuideChatPresenter.swift
//  Disciplinizer
//
//  Created by Anton on 10.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol GuideChatPresenterProtocol {
    func didTapGotItButton()
}

final class GuideChatPresenter: GuideChatPresenterProtocol {
    weak var view: GuideChatViewProtocol!

    required init(view: GuideChatViewProtocol) {
        self.view = view
    }
    
    func didTapGotItButton() {
        view.router?.present(Controller.guide())
    }
}
