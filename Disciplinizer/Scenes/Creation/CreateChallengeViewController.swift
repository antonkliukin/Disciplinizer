//
//  CreateChallengeViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 09/10/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol CreateChallengeViewProtocol: ViewProtocol {
    func set(viewTitle: String)
    func set(startButtonTitle: String)
    func changeStartButtonState(isActive: Bool)
    func configureTimeView(model: ParameterViewModel)
    func configureMotivationView(model: ParameterViewModel)
}

final class CreateChallengeViewController: UIViewController, CreateChallengeViewProtocol {
    @IBOutlet weak var contentViewLabel: UILabel!
    @IBOutlet weak var motivationTypeParameterView: ChallengeParameterView!
    @IBOutlet weak var timeParameterView: ChallengeParameterView!
    @IBOutlet weak var startButtonShadowView: UIView!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet weak var topBackgroundView: UIView!

    private let configurator = CreateChallengeConfigurator()

    var presenter: CreateChallengePresenterProtocol!

    // MARK: View Protocol

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
        startButton.addShadow(alpha: 0.15, blur: 15)
        startButton.titleLabel?.adjustsFontSizeToFitWidth = true

        startButtonShadowView.roundCorners(corners: .all, radius: startButtonShadowView.bounds.width / 2)
        startButtonShadowView.addShadow(alpha: 0.15, blur: 4)
    }
    
    func set(viewTitle: String) {
        title = viewTitle
        contentViewLabel.text = title
    }
    
    func set(startButtonTitle: String) {
        startButton.setTitle(startButtonTitle, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupTopView()
        configureStartButton()
        
        configurator.configure(createChallengeViewController: self)
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_  animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        presenter.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewDidAppear()
    }
    
    @IBAction private func startButtonTapped(_ sender: Any) {
        presenter.startButtonTapped()
    }
        
    private func setupTopView() {
        topBackgroundView.roundCorners(corners: .bottom, radius: 24)
    }
}
