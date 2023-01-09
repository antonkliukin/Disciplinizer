//
//  AdViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 14.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol AdViewProtocol: ViewProtocol {

}

class AdViewController: UIViewController, AdViewProtocol {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var presenter: AdPresenterProtocol?
    var configurator: AdConfigurator?

    override func viewDidLoad() {
      super.viewDidLoad()

        configurator?.configure(adViewController: self)
        presenter?.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .white
        }
    }
}
