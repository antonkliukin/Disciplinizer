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
}

final class CreateChallengeViewController: UIViewController, CreateChallengeViewProtocol {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewLabel: UILabel!
    @IBOutlet weak var motivationTypeParameterView: ChallengeParameterView!
    @IBOutlet weak var timeParameterView: ChallengeParameterView!
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
        return Double(timeParameterView.parameterValueLabel.text ?? "0") ?? 0
    }

    var selectedBetId: String {
        return bets[currentBetIndex].id
    }
    
    func changeStartButtonState(isActive: Bool) {
        startButton.alpha = isActive ? 1 : 0.5
        startButton.isEnabled = isActive
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
        
        configurator.configure(createChallengeViewController: self)
        
        setupNavigationBar()

        presenter.viewDidLoad()
    }
    
    @IBAction private func startButtonTapped(_ sender: Any) {
        presenter.startButtonTapped()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupContentView() {
        contentViewLabel.text = title
        contentView.roundCorners(corners: .top, radius: 22)
    }
}
