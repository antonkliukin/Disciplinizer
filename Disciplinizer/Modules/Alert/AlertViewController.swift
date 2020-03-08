//
//  AlertViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 24/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol AlertViewProtocol: ViewProtocol {
    func setMessageText(_ text: String)
}

class AlertViewController: UIViewController, AlertViewProtocol {

    @IBOutlet weak var titleLabel: UILabel?

    var presenter: AlertPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        presenter?.didTapDismiss()
    }

    func setMessageText(_ text: String) {
        titleLabel?.text = text
    }
    
}
