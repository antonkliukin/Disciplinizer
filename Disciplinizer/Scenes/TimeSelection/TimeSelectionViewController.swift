//
//  MotivationSelectionViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol TimeSelectionViewProtocol: ViewProtocol {
    func set(viewTitle: String)
    func set(description: String)
    func set(placeholder: String)
    func set(saveButtonTitle: String)
    func showErrorMessage(_ message: String)
    func hideErrorMessage()
    func changeSaveButtonState(isEnabled: Bool)
    func clearInput()
}

class TimeSelectionViewController: UIViewController, TimeSelectionViewProtocol {
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var timeTextFieldLineView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var saveButton: MainButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var presenter: TimeSelectionPresenterProtocol!
    var configurator: TimeSelectionConfiguratorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator?.configure(timeSelectionViewController: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        timeTextField.becomeFirstResponder()
                
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
    }
        
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        if let keyboardFramveValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
            var keyboardFrame: CGRect = keyboardFramveValue.cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            var contentInset: UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height + 20
            scrollView.contentInset = contentInset
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func set(viewTitle: String) {
        titleLabel.text = viewTitle
    }
    
    func set(description: String) {
        descriptionLabel.text = description
    }
    
    func set(placeholder: String) {
        timeTextField.placeholder = placeholder
    }
    
    func set(saveButtonTitle: String) {
        saveButton.setTitle(saveButtonTitle, for: .normal)
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
