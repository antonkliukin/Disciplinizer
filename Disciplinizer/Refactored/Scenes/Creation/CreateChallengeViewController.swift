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
    func configureTimeView(model: ParameterViewModel)
    func configureMotivationView(model: ParameterViewModel)
}

final class CreateChallengeViewController: UIViewController, CreateChallengeViewProtocol {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewLabel: UILabel!
    @IBOutlet weak var motivationTypeParameterView: ChallengeParameterView!
    @IBOutlet weak var timeParameterView: ChallengeParameterView!
    @IBOutlet private weak var startButton: UIButton!

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
        return Double(timeParameterView.parameterValueLabel.text ?? "0") ?? 0
    }

    var selectedBetId: String {
        return bets[currentBetIndex].id
    }
    
    func changeStartButtonState(isActive: Bool) {
        startButton.alpha = isActive ? 1 : 0.5
        startButton.isEnabled = isActive
    }
    
    func configureTimeView(model: ParameterViewModel) {
        timeParameterView.configure(model: model)
    }
    
    func configureMotivationView(model: ParameterViewModel) {
        motivationTypeParameterView.configure(model: model)
    }
    
    func configureStartButton() {
        startButton.roundCorners(corners: .all, radius: startButton.bounds.width / 2)
        startButton.layer.borderWidth = 10
        startButton.layer.borderColor = R.color.buttonLightBlue()!.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
        configureStartButton()
        
        configurator.configure(createChallengeViewController: self)
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction private func startButtonTapped(_ sender: Any) {
        presenter.startButtonTapped()
    }
        
    private func setupContentView() {
        contentViewLabel.text = title
        contentView.roundCorners(corners: .top, radius: 22)
    }
}
