//
//  LosingViewController.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 09.11.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import UIKit

protocol LosingViewProtocol: ViewProtocol {
    func configureLoseMessage(_ message: String)
    func setButtonTitle(_ title: String)
    func showError(_ message: String)
}

final class LosingViewController: UIViewController, LosingViewProtocol {
    @IBOutlet private weak var loseMessageLabel: UILabel!
    @IBOutlet private weak var purchaseButton: MainButton!

    var presenter: LosingPresenterProtocol?

    override func viewDidLoad() {
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
