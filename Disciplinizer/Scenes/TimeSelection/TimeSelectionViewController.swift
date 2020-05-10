//
//  MotivationSelectionViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol TimeSelectionViewProtocol: ViewProtocol {
    func showErrorMessage(_ message: String)
    func hideErrorMessage()
    func changeSaveButtonState(isEnabled: Bool)
    func clearInput()
}

class TimeSelectionViewController: UIViewController, TimeSelectionViewProtocol {
    
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var timeTextFieldLineView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var saveButton: MainButton!
    
    var presenter: TimeSelectionPresenterProtocol!
    var configurator: TimeSelectionConfiguratorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator?.configure(timeSelectionViewController: self)
                
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
    }
        
    func showErrorMessage(_ message: String) {
        errorMessageLabel.text = message
        timeTextFieldLineView.backgroundColor = R.color.errorRed()
    }
    
    func hideErrorMessage() {
        errorMessageLabel.text = " "
        timeTextFieldLineView.backgroundColor = R.color.lightBlue()
    }
    
    func changeSaveButtonState(isEnabled: Bool) {
        saveButton.isResponsive = isEnabled
    }
    
    @IBAction func didEnterNumber(_ sender: Any) {
        guard let enteredText = timeTextField.text else {
            return
        }
        
        presenter?.didEnter(enteredText)
    }
    
    func clearInput() {
        timeTextField.text = ""
    }
    
    @IBAction func didTapSave(_ sender: Any) {
        presenter?.didTapSaveButton()
    }
}
