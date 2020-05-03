//
//  CurrentChallengeViewController.swift
//  Disciplinizer
//
//  Created by Alexander Bakhmut on 20.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

// MARK: - Current Challenge View Protocol

protocol CurrentChallengeViewProtocol: ViewProtocol {
    var isDeviceLocked: Bool { get }
    func updateTimer(time: String)
}

// MARK: - Current Challenge View Controller

final class CurrentChallengeViewController: UIViewController, CurrentChallengeViewProtocol {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var giveUpButton: MainButton!
    @IBOutlet weak var musicSelectionButton: UIButton!
    
    var presenter: CurrentChallengePresenterProtocol?
    var configurator: CurrentChallengeConfiguratorProtocol?

    var isDeviceLocked: Bool {
        UIScreen.main.brightness == 0.0
    }

    private var notifCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator?.configure(currentChallengeViewController: self)
        
        setupUI()
        
        presenter?.viewDidLoad()

        addAppDelegateObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.viewDidAppear()
    }
    
    private func setupUI() {
        giveUpButton.roundCorners(corners: .all, radius: giveUpButton.bounds.size.height / 2)
        musicSelectionButton.roundCorners(corners: .all, radius: musicSelectionButton.bounds.size.height / 2)
    }

    @IBAction private func didTapGiveUpButton(_ sender: MainButton) {
        presenter?.didTapStopChallenge()
    }
    
    
    @IBAction private func didTapMusicSelectionButton(_ sender: Any) {
        presenter?.didTapMusicSelection()
    }
            
    func updateTimer(time: String) {
        timerLabel.text = time
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
