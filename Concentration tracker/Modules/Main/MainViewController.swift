//
//  MainViewController.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 22/08/2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import UIKit

protocol MainViewProtocol: ViewProtocol {
    func setButtonLabel(label: String)
}

class MainViewController: UIViewController, MainViewProtocol {
    @IBOutlet weak var mainButton: UIButton?

    var presenter: MainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func setButtonLabel(label: String) {
        mainButton?.setTitle(label, for: .normal)
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        presenter?.playButtonTapped()
    }
    @IBAction func actionButtonTapped(_ sender: Any) {
        presenter?.viewDidSomething()
    }
}
