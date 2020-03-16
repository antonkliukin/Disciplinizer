//
//  CreateChallengeViewController.swift
//  Disciplinizer
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
    func setupBetSelector(withPossibleBets bets: [BetProtocol])
    func setupModeSelectorWith(_ mode: ChallengeMode)
    func setupDurationSelectorWith(minutes: Int)
}

final class CreateChallengeViewController: UIViewController, CreateChallengeViewProtocol {

    @IBOutlet weak var motivationTypeView: UIView!
    @IBOutlet weak var motivationViewTitleLabel: UILabel!
    @IBOutlet weak var motivationTypeTitleLabel: UILabel!
    @IBOutlet weak var tapToChangeMotivationLabel: UILabel!

    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeViewTitleLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var tapToChangeTimeLabel: UILabel!

    @IBOutlet private weak var startButton: MainButton!

    private let configurator = CreateChallengeConfigurator()
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    private var currentBetIndex = 0
    private var bets: [BetProtocol] = []

    var presenter: CreateChallengePresenterProtocol!

    // MARK: View Protocol

    var selectedMode: ChallengeMode? {
        // TODO: Replace with something
        return ChallengeMode.free
    }

    var selectedDuration: TimeInterval {
        // TODO: change
        return Double(timeTitleLabel.text ?? "0") ?? 0
    }

    var selectedBetId: String {
        return bets[currentBetIndex].id
    }

    func changeStartButtonState(isActive: Bool) {
        startButton.alpha = isActive ? 1 : 0.5
        startButton.isEnabled = isActive
    }

    func setupBetSelector(withPossibleBets bets: [BetProtocol]) {

    }

    func setupModeSelectorWith(_ mode: ChallengeMode) {

    }

//    func setupBetSelector(withPossibleBets bets: [BetProtocol]) {
//        DispatchQueue.main.async {
//        self.bets = bets
//        let values = Array(0..<bets.count)
//            self.betSlider.minimumValue = Float(values.min() ?? 0)
//            self.betSlider.maximumValue = Float(values.max() ?? 0)
//
//            self.currentBetIndex = values.last ?? 0
//            self.betSlider.value = Float(self.currentBetIndex)
//
//            if self.currentBetIndex < bets.count {
//                self.betLabel.text = bets[self.currentBetIndex].localizedPrice ?? "Loading bets..."
//        }
//
//            self.betSlider.addTarget(self, action: #selector(self.betSliderDidChanged(sender:)), for: .valueChanged)
//        }
//    }

    func setupDurationSelectorWith(minutes: Int) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = title

        addTapGestures()

        configurator.configure(createChallengeViewController: self)

        presenter.viewDidLoad()
    }

    private func addTapGestures() {
        let tapMotivationGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMotivationView))
        motivationTypeView.addGestureRecognizer(tapMotivationGesture)

        let tapTimeGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTimeView))
        timeView.addGestureRecognizer(tapTimeGesture)
    }

    @objc private func didTapMotivationView() {
        presenter.didTapChangeMotivation()
    }

    @objc private func didTapTimeView() {
        presenter.didTapChangeTime()
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
                // betLabel.text = bets[currentBetIndex].localizedPrice ?? "Localized Price"
            }
        }
    }

    @IBAction private func startButtonTapped(_ sender: Any) {
        presenter.startButtonTapped()
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
