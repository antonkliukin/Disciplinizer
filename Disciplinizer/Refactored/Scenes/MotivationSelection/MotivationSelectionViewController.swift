//
//  MotivationSelectionViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol MotivationSelectionViewProtocol: ViewProtocol {
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
