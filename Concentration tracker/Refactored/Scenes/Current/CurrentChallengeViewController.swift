//
//  CurrentChallengeViewController.swift
//  Concentration tracker
//
//  Created by Alexander Bakhmut on 20.10.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import UIKit

// MARK: - Current Challenge View Protocol

protocol CurrentChallengeViewProtocol: ViewProtocol {
    func updateTimer(time: String)
    func updatePlayButton()
}

// MARK: - Current Challenge View Controller

final class CurrentChallengeViewController: UIViewController, CurrentChallengeViewProtocol {
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var musicSelectView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stopButton: MainButton!
    @IBOutlet weak var playSoundButton: UIButton!
    
    var presenter: CurrentChallengePresenterProtocol?
    var configurator: CurrentChallengeConfiguratorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator?.configure(currentChallengeViewController: self)
        
        presenter?.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.viewDidAppear()
    }

    @IBAction private func onStopButtonTap(_ sender: MainButton) {
        presenter?.didTapStopChallenge()
    }
    
    @IBAction private func onMusicSelectTap(_ sender: UIButton) {
        presenter?.didTapMusicSelect()
    }
    
    @IBAction private func onPlaySoundTap(_ sender: UIButton) {
        presenter?.didTapPlayButton()
        updatePlayButton()
    }
    
    func updateTimer(time: String) {
        timerLabel.text = time
    }
    
    func updatePlayButton() {
        let image = (SoundManager.shared.selectedSong?.sound?.playing ?? false) ? R.image.playFill() :  R.image.play()
        playSoundButton.setImage(image, for: .normal)
    }

    private func setupUI() {
        timerView.roundCorners()
        timerView.addShadow()
        musicSelectView.roundCorners()
        musicSelectView.addShadow(opacity: 0.1)
    }
}
