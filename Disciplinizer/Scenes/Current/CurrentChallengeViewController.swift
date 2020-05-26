//
//  CurrentChallengeViewController.swift
//  Disciplinizer
//
//  Created by Alexander Bakhmut on 20.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol CurrentChallengeViewProtocol: ViewProtocol {
    func display(timerTitle: String)
    func display(timerDescription: String)
    func display(giveUpButtonTitle: String)
    func display(congratsTitle: String)
    func display(backToMenuButtonTitle: String)
    func hideGiveUpButton()
    func hideMusicSelectionButton()
    func updateTimer(timeUnits: TimeUnits)
}

final class CurrentChallengeViewController: UIViewController, CurrentChallengeViewProtocol {
    @IBOutlet weak var timerTitleLabel: UILabel!
    @IBOutlet weak var timerDescriptionLabel: UILabel!
    
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    
    @IBOutlet weak var giveUpButton: MainButton!
    @IBOutlet weak var musicSelectionButton: UIButton!
    @IBOutlet weak var backToMenuButton: MainButton!
    @IBOutlet weak var congratsLabel: UILabel!
    
    var presenter: CurrentChallengePresenterProtocol?
    var configurator: CurrentChallengeConfiguratorProtocol?

    private var notifCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator?.configure(currentChallengeViewController: self)
        
        configureUI()
        
        addAppDelegateObservers()
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.viewDidAppear()
    }
    
    func display(timerTitle: String) {
        timerTitleLabel.text = timerTitle
    }
    
    func display(timerDescription: String) {
        timerDescriptionLabel.text = timerDescription
    }
    
    func display(giveUpButtonTitle: String) {
        giveUpButton.setTitle(giveUpButtonTitle, for: .normal)
    }
    
    func display(congratsTitle: String) {
        congratsLabel.text = congratsTitle
        congratsLabel.isHidden = false
    }
    
    func display(backToMenuButtonTitle: String) {
        backToMenuButton.setTitle(backToMenuButtonTitle, for: .normal)
        backToMenuButton.isHidden = false
    }
    
    func hideGiveUpButton() {
        giveUpButton.isHidden = true
    }
    
    func hideMusicSelectionButton() {
        musicSelectionButton.isHidden = true
    }
    
    func updateTimer(timeUnits: TimeUnits) {
        hoursLabel.text = timeUnits.hours
        minutesLabel.text = timeUnits.minutes
        secondsLabel.text = timeUnits.seconds
    }
    
    private func configureUI() {
        giveUpButton.roundCorners(corners: .all, radius: giveUpButton.bounds.size.height / 2)
        musicSelectionButton.roundCorners(corners: .all, radius: musicSelectionButton.bounds.size.height / 2)
    }

    @IBAction private func didTapGiveUpButton(_ sender: MainButton) {
        presenter?.didTapStopChallenge()
    }
    
    @IBAction private func didTapMusicSelectionButton(_ sender: Any) {
        presenter?.didTapMusicSelection()
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        presenter?.didTapBackButton()
    }
                
    private func addAppDelegateObservers() {
        notifCenter.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notifCenter.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        notifCenter.addObserver(self, selector: #selector(willTerminate), name: UIApplication.willTerminateNotification, object: nil)
        notifCenter.addObserver(self, selector: #selector(willResingActive), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc private func willResingActive() {
        presenter?.willLeaveApp()
    }

    @objc private func didEnterBackground() {
        presenter?.didLeaveApp()
    }

    @objc private func didBecomeActive() {
        presenter?.didReturnToApp()
    }

    @objc private func willTerminate() {
        presenter?.didCloseApp()
    }
}
