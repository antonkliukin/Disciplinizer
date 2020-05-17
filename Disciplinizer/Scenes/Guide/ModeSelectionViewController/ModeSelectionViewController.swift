//
//  ModeSelectionViewController.swift
//  Disciplinizer
//
//  Created by Anton on 10.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol ModeSelectionViewProtocol: ViewProtocol {
    func display(titleText: String)
    func display(descriptionText: String)
    func configureCatModeView(title: String, desctiption: String, image: UIImage)
    func changeCatModeViewState(_ state: GuideModeSelecionViewState)
    func configureTimeModeView(title: String, desctiption: String, image: UIImage)
    func changeTimeModeViewState(_ state: GuideModeSelecionViewState)
    func display(message: String)
    func configureNextButtonTitle(title: String)
}

class ModeSelectionViewController: UIViewController, ModeSelectionViewProtocol {
      
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var catModeSelectionView: GuideModeSelecionView!
    @IBOutlet weak var timeModeSelectionView: GuideModeSelecionView!
    @IBOutlet weak var messageView: GuideMessageView!
    @IBOutlet weak var messageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nextButton: MainButton!
    
    
    @IBOutlet weak var stackView: UIStackView!
    
        
    var presenter: ModeSelectionPresenterProtocol!
    var configurator: ModeSelectoinConfiguratorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator?.configure(modeSelectionViewController: self)
        
        let catModeTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCatMode))
        catModeSelectionView.addGestureRecognizer(catModeTapGesture)

        let timeModeTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTimeMode))
        timeModeSelectionView.addGestureRecognizer(timeModeTapGesture)
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMessageViewHeight()
    }
    
    private func updateMessageViewHeight() {
        let messageText = messageView.messageLabel.text
        if let text = messageText {
            let size = text.estimateFrameForText(ofFont: .systemFont(ofSize: 15), inRect: CGSize(width: stackView.bounds.width - 65, height: 100))
            messageViewHeight.constant = size.height + 40
        }
    }
        
    @objc private func didTapCatMode() {
        presenter.didTapCatMode()
    }
    
    @objc private func didTapTimeMode() {
        presenter.didTapTimeMode()
    }
    
    func changeCatModeViewState(_ state: GuideModeSelecionViewState) {
        catModeSelectionView.changeState(state)
    }
    
    func changeTimeModeViewState(_ state: GuideModeSelecionViewState) {
        timeModeSelectionView.changeState(state)
    }
    
    func display(titleText: String) {
        titleLabel.text = titleText
    }
    
    func display(descriptionText: String) {
        descriptionLabel.text = descriptionText
    }
    
    func configureCatModeView(title: String, desctiption: String, image: UIImage) {
        catModeSelectionView.configure(title: title, description: desctiption, image: image)
    }
    
    func configureTimeModeView(title: String, desctiption: String, image: UIImage) {
        timeModeSelectionView.configure(title: title, description: desctiption, image: image)
    }
    
    func display(message: String) {
        messageView.messageLabel.text = message
        updateMessageViewHeight()
    }
    
    func configureNextButtonTitle(title: String) {
        nextButton.setTitle(title, for: .normal)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        presenter.didTapNextButton()
    }
}
