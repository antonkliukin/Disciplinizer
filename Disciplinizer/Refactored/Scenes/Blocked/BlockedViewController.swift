//
//  BlockedViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 09.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol BlockedViewProtocol: ViewProtocol {
    func configureLoseMessage(_ message: String)
    func setButtonTitle(_ title: String)
    func showError(_ message: String)
}

final class BlockedViewController: UIViewController, BlockedViewProtocol {
    @IBOutlet private weak var loseMessageLabel: UILabel!
    @IBOutlet private weak var purchaseButton: MainButton!

    var presenter: BlockedPresenterProtocol?
    var configurator: BlockedStateConfiguratorProtocol?

    override func viewDidLoad() {
        configurator?.configure(blockedViewController: self)
        presenter?.viewDidLoad()
    }

    @IBAction func purchaseButtonTapped(_ sender: Any) {
        presenter?.didTapPurchase()
    }

    func configureLoseMessage(_ message: String) {
        loseMessageLabel.text = message
    }

    func setButtonTitle(_ title: String) {
        purchaseButton.setTitle(title, for: .normal)
    }

    func showError(_ message: String) {
        // TODO: Present alert here
    }
}
