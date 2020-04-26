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
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var musicSelectView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stopButton: MainButton!
    @IBOutlet weak var playSoundButton: UIButton!
    
    var presenter: CurrentChallengePresenterProtocol?
    var configurator: CurrentChallengeConfiguratorProtocol?

    var isDeviceLocked: Bool {
        UIScreen.main.brightness == 0.0
    }

    private var notifCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator?.configure(currentChallengeViewController: self)
        
        presenter?.viewDidLoad()
        setupUI()
        addAppDelegateObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.viewDidAppear()
    }

    @IBAction private func onStopButtonTap(_ sender: MainButton) {
        presenter?.didTapStopChallenge()
    }
    
    @IBAction private func onMusicSelectTap(_ sender: UIButton) {
        presenter?.didTapMusicSelection()
    }
        
    func updateTimer(time: String) {
        timerLabel.text = time
    }

    private func setupUI() {
//        timerView.roundCorners()
//        timerView.addShadow()
//        musicSelectView.roundCorners()
//        musicSelectView.addShadow(opacity: 0.1)
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
