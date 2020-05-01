//
//  MotivationSelectionViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol MotivationSelectionViewProtocol: ViewProtocol {
    func changeSetButtonTitle(title: String)
    func changeSetButtonState(isResponsive: Bool)
    func selectIndex(_ index: Int)
    func configureMotivationView(title: String,
                                 itemImage: UIImage,
                                 descriptionTitle: String,
                                 description: String,
                                 info: String,
                                 actionButtonTitle: String,
                                 actionButtonAction: @escaping () -> Void)
}

class MotivatonSelectionViewController: UIViewController, MotivationSelectionViewProtocol {
    @IBOutlet weak var motivationItemView: MotivationView!
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var setButton: MainButton!
    
    var presenter: MotivationSelectionPresenterProtocol!
    let configurator = MotivationSelectionConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(motivationSelectionViewController: self)
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
    }
    
    func changeSetButtonTitle(title: String) {
        setButton.setTitle(title, for: .normal)
    }
    
    func changeSetButtonState(isResponsive: Bool) {
        setButton.isResponsive = isResponsive
    }
    
    func configureMotivationView(title: String,
                                 itemImage: UIImage,
                                 descriptionTitle: String,
                                 description: String,
                                 info: String,
                                 actionButtonTitle: String,
                                 actionButtonAction: @escaping () -> Void) {
        motivationItemView.configure(title: title,
                                     itemImage: itemImage,
                                     descriptionTitle: descriptionTitle,
                                     description: description,
                                     info: info,
                                     actionButtonTitle: actionButtonTitle,
                                     actionButtonAction: actionButtonAction)
    }
    
    func selectIndex(_ index: Int) {
        modeSegmentedControl.selectedSegmentIndex = index
    }
    
    @IBAction func didSelectMode(_ sender: Any) {
        if let segmentedControl = sender as? UISegmentedControl {
            let selectedIndex = segmentedControl.selectedSegmentIndex
            presenter.didSelectIndex(selectedIndex)
        }
    }
    
    @IBAction func setModeButtonTapped(_ sender: Any) {
        presenter.didTapSetModeButton()
    }
}
