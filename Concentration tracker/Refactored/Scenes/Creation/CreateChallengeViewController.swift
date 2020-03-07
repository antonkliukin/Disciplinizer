//
//  CreateChallengeViewController.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 09/10/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol CreateChallengeViewProtocol: ViewProtocol {
    var selectedMode: ChallengeMode? { get }
    var selectedDuration: TimeInterval { get }
    var selectedBetId: String { get }

    func changeStartButtonState(isActive: Bool)
    func setupBetSlider(withPossibleBets bets: [BetProtocol])
}

final class CreateChallengeViewController: UIViewController, CreateChallengeViewProtocol {
    @IBOutlet private weak var mainViewTop: NSLayoutConstraint!
    @IBOutlet private weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var mainView: RoundedView!
    private var initialMainViewTop: CGFloat = 0
    private var initialMainViewHeight: CGFloat = 0

    @IBOutlet private weak var modeView: RoundedView!
    @IBOutlet private weak var modeTitleLabel: UILabel!
    @IBOutlet private weak var modeSegmentedControl: UISegmentedControl!

    @IBOutlet private weak var timerView: RoundedView!
    @IBOutlet private weak var timerTitleLabel: UILabel!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var timerSlider: UISlider!
    @IBOutlet private weak var timerViewTop: NSLayoutConstraint!
    @IBOutlet private weak var timerViewHeight: NSLayoutConstraint!
    private var initialTimerViewTop: CGFloat = 0
    private var initialTimerViewHeight: CGFloat = 0

    @IBOutlet private weak var betView: RoundedView!
    @IBOutlet private weak var betTitleLabel: UILabel!
    @IBOutlet private weak var betLabel: UILabel!
    @IBOutlet private weak var betSlider: UISlider!
    @IBOutlet private weak var betViewTop: NSLayoutConstraint!
    @IBOutlet private weak var betViewHeight: NSLayoutConstraint!
    private var initialBetViewTop: CGFloat = 0
    private var initialBetViewHeight: CGFloat = 0

    @IBOutlet private weak var startButton: MainButton!

    private let configurator = CreateChallengeConfigurator()
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    private var currentBetIndex = 0
    private var bets: [BetProtocol] = []

    var presenter: CreateChallengePresenter?

    var selectedMode: ChallengeMode? {
        guard modeSegmentedControl.selectedSegmentIndex >= 0 else {
            return nil
        }
        
        let mode: ChallengeMode = modeSegmentedControl.selectedSegmentIndex == 0 ? .paid : .free
        return mode
    }

    var selectedDuration: TimeInterval {
        return Double(timerSlider.value)
    }

    var selectedBetId: String {
        return bets[currentBetIndex].id
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(createChallengeViewController: self)

        setupMainView()

        setupTimer()
        setupTimerView()

        setupModeView()
        setupModePicker()

        setupBetView()

        hideBetView(true, animated: false)
        hideTimerView(true, animated: false)

        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter?.viewWillAppear()
    }

    private func setupMainView() {
        initialMainViewTop = mainViewTop.constant
        initialMainViewHeight = mainViewHeight.constant
    }

    private func hideMainView(_ hide: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.mainViewTop.constant = hide ? 0 : self.initialMainViewTop
            self.mainViewHeight.constant = hide ? 0 : self.initialMainViewHeight
            self.view.layoutIfNeeded()
        }
    }

    private func setupTimer() {
        timerSlider.minimumValue = 10
        timerSlider.maximumValue = 120
        timerSlider.value = 10
        timerSlider.addTarget(self, action: #selector(timerSliderDidChanged(sender:)), for: .valueChanged)
    }

    func setupBetSlider(withPossibleBets bets: [BetProtocol]) {
        DispatchQueue.main.async {
        self.bets = bets
        let values = Array(0..<bets.count)
            self.betSlider.minimumValue = Float(values.min() ?? 0)
            self.betSlider.maximumValue = Float(values.max() ?? 0)
        
            self.currentBetIndex = values.last ?? 0
            self.betSlider.value = Float(self.currentBetIndex)

            if self.currentBetIndex < bets.count {
                self.betLabel.text = bets[self.currentBetIndex].localizedPrice ?? "Loading bets..."
        }

            self.betSlider.addTarget(self, action: #selector(self.betSliderDidChanged(sender:)), for: .valueChanged)
        }
    }

    private func setupModePicker() {
        modeSegmentedControl.addTarget(self, action: #selector(modePickerDidChanged(sender:)), for: .valueChanged)
    }

    private func setupModeView() {
    }

    private func setupTimerView() {
        initialTimerViewTop = timerViewTop.constant
        initialTimerViewHeight = timerViewHeight.constant
    }

    private func hideTimerView(_ hide: Bool, animated: Bool = true) {
        self.timerViewTop.constant = hide ? 0 : self.initialTimerViewTop
        self.timerViewHeight.constant = hide ? 0 : self.initialTimerViewHeight

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    private func setupBetView() {
        initialBetViewTop = betViewTop.constant
        initialBetViewHeight = betViewHeight.constant
    }

    private func hideBetView(_ hide: Bool, animated: Bool = true) {
        self.betViewTop.constant = hide ? 0 : self.initialBetViewTop
        self.betViewHeight.constant = hide ? 0 : self.initialBetViewHeight

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func modePickerDidChanged(sender: UISegmentedControl) {
        hideMainView(true)
        hideTimerView(false)
        hideBetView(sender.selectedSegmentIndex == 1)

        if let mode = selectedMode {
            presenter?.didChooseMode(mode)
        }
    }

    @objc private func timerSliderDidChanged(sender: UISlider) {
        timerLabel.text = "\(Int(sender.value)) Min"
    }

    @objc private func betSliderDidChanged(sender: UISlider) {
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()

        let step: Float = 1
        let roundedValue = round(sender.value / step) * step

        if roundedValue != Float(currentBetIndex) {
            feedbackGenerator?.selectionChanged()
            feedbackGenerator = nil
            
            currentBetIndex = Int(roundedValue)

            if currentBetIndex < bets.count {
                betLabel.text = bets[currentBetIndex].localizedPrice ?? "Localized Price"
            }
        }
    }

    func changeStartButtonState(isActive: Bool) {
        startButton.alpha = isActive ? 1 : 0.5
        startButton.isEnabled = isActive
    }

    @IBAction private func startButtonTapped(_ sender: Any) {
        presenter?.startButtonTapped()
    }
}

final class RoundedView: UIView {
    override init (frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    func setup () {
        roundCorners()
    }
}

final class ShadowView: UIView {
    override init (frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }

    func setup () {
        roundCorners()
        addShadow()
    }
}
