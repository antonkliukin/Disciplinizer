//
//  MotivationSelectionViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol TimeSelectionViewProtocol: ViewProtocol {

}

class TimeSelectionViewController: UIViewController, TimeSelectionViewProtocol {
    var presenter: TimeSelectionPresenterProtocol!
    var configurator = TimeSelectionConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(timeSelectionViewController: self)
    }
}
