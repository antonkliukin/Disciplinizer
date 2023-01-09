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
    func viewDidLoad()
}

final class GuideChatPresenter: GuideChatPresenterProtocol {
    weak var view: GuideChatViewProtocol!

    required init(view: GuideChatViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.set(nextButtonTitle: R.string.localizable.guideGotItTitle())
        view?.set(typingLabelText: R.string.localizable.guideTypingText())
    }
    
    func didTapGotItButton() {
        view.router?.add(Controller.guide(), frame: nil, animated: true)
    }
}
