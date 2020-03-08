//
//  SettingsViewController.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 10.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol SettingsViewProtocol: ViewProtocol {
    func  updateMusicConfiguration(with model: SongModel)
}

class SettingsViewController: UIViewController, SettingsViewProtocol {
    var presenter: SettingsPresenterProtocol?
    //TODO: VERY bad design. Sound create custom view at least. (or Cell + Table View)
    @IBOutlet private weak var songNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedSong = SoundManager.shared.selectedSong {
            updateMusicConfiguration(with: selectedSong)
        }
    }
    
    @IBAction private func selectMusicButtonTapped(_ sender: Any) {
        presenter?.didTapMusicSelect()
    }
    
    func updateMusicConfiguration(with model: SongModel) {
        songNameLabel.text = model.title
    }
}
