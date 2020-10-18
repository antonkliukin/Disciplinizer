//
//  GuideChatConfigurator.swift
//  Disciplinizer
//
//  Created by Anton on 10.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol GuideChatConfiguratorProtocol {
    func configure(guideChatViewController: GuideChatViewController)
}

final class GuideChatConfigurator: GuideChatConfiguratorProtocol {
    func configure(guideChatViewController: GuideChatViewController) {
        let presenter = GuideChatPresenter(view: guideChatViewController)
        guideChatViewController.presenter = presenter
    }
}
