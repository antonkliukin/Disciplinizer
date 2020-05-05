//
//  CreateChallengeViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 09/10/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol CreateChallengeViewProtocol: ViewProtocol {
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
        startButton.layer.borderWidth = 10
        startButton.layer.borderColor = R.color.buttonLightBlue()!.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Delete test data
//        UserDefaults.standard.set("-1", forKey: "purchasedItem")
//        UserDefaults.standard.set("0", forKey: "selectedItem")
//        UserDefaults.standard.set(23, forKey: "selectedTime")
        
        setupContentView()
        configureStartButton()
        
        configurator.configure(createChallengeViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        presenter.viewWillAppear()
    }
    
    @IBAction private func startButtonTapped(_ sender: Any) {
        presenter.startButtonTapped()
    }
        
    private func setupContentView() {
        contentViewLabel.text = title
        contentView.roundCorners(corners: .top, radius: 22)
    }
}
