//
//  SettingsViewController.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 10.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol SettingsViewProtocol: ViewProtocol {

}

class SettingsViewController: UIViewController, SettingsViewProtocol {
    var presenter: SettingsPresenterProtocol?

    @IBOutlet private weak var songNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = title
    }
    
    @IBAction private func selectMusicButtonTapped(_ sender: Any) {
        presenter?.didTapMusicSelect()
    }
    
    func updateMusicConfiguration(with model: Song) {
        songNameLabel.text = model.title
    }
}
