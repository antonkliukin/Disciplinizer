//
//  MotivationSelectionViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol MotivationSelectionViewProtocol: ViewProtocol {
    func set(viewTitle: String)
    func set(titleForIndexOne: String, indexTwo: String)
    func changeSetButtonTitle(title: String)
    func changeSetButtonState(isResponsive: Bool)
    func selectIndex(_ index: Int)
    func displayMotivationView(withItem item: MotivationalItem, didTapActionButton: @escaping () -> Void)
}

class MotivatonSelectionViewController: UIViewController, MotivationSelectionViewProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var motivationItemView: MotivationView!
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var setButton: MainButton!
    
    var presenter: MotivationSelectionPresenterProtocol!
    let configurator = MotivationSelectionConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(motivationSelectionViewController: self)
        
        setupModeSegmentedControl()
                
        presenter.viewDidLoad()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
    }
        
    func set(viewTitle: String) {
        titleLabel.text = viewTitle
    }
    
    func set(titleForIndexOne: String, indexTwo: String) {
        modeSegmentedControl.setTitle(titleForIndexOne, forSegmentAt: 0)
        modeSegmentedControl.setTitle(indexTwo, forSegmentAt: 1)
    }
    
    func setupModeSegmentedControl() {
        if #available(iOS 13, *) {
            return
        } else {
            modeSegmentedControl.tintColor = .lightGray
            modeSegmentedControl.backgroundColor = .white

            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            modeSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
            modeSegmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        }
    }
    
    func changeSetButtonTitle(title: String) {
        setButton.setTitle(title, for: .normal)
    }
    
    func changeSetButtonState(isResponsive: Bool) {
        setButton.isResponsive = isResponsive
    }
    
    func displayMotivationView(withItem item: MotivationalItem, didTapActionButton: @escaping () -> Void) {
        motivationItemView.configure(withItem: item, didTapActionButton: didTapActionButton)
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
