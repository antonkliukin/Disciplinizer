//
//  MotivationSelectionViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol MotivationSelectionViewProtocol: ViewProtocol {
    func setPaidMotivationTitle(text: String)
    func setPaidMotivationDescription(text: String)
    func setTimeMotivationTitle(text: String)
    func setTimeMotivationDescription(text: String)
    func setMainButtonTitle(text: String)
}

class MotivatonSelectionViewController: UIViewController, MotivationSelectionViewProtocol {
    @IBOutlet weak var mainButton: MainButton!

    @IBOutlet weak var paidMotivatoinView: UIView!
    @IBOutlet weak var paidMotivationTitleLabel: UILabel!
    @IBOutlet weak var paidMotivationDescriptionLabel: UILabel!

    @IBOutlet weak var timeMotivationView: UIView!
    @IBOutlet weak var timeMotivationTitleLabel: UILabel!
    @IBOutlet weak var timeMotivationtDescriptionLabel: UILabel!

    var presenter: MotivationSelectionPresenterProtocol!
    var configurator = MotivationSelectionConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(motivationSelectionViewController: self)

        addTapGestures()
    }

    private func addTapGestures() {
        let paidViewTap = UITapGestureRecognizer(target: self, action: #selector(paidMotivationViewTapped))
        paidMotivatoinView.addGestureRecognizer(paidViewTap)

        let timeViewTap = UITapGestureRecognizer(target: self, action: #selector(timeMotivationViewTapped))
        timeMotivationView.addGestureRecognizer(timeViewTap)
    }

    @objc private func paidMotivationViewTapped() {
        presenter.didSelectPaidMotivation()
    }

    @objc private func timeMotivationViewTapped() {
        presenter.didSelectTimeMotivation()
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        presenter.didTapSaveButton()
    }

    func setPaidMotivationTitle(text: String) {
        paidMotivationTitleLabel.text = text
    }

    func setPaidMotivationDescription(text: String) {
        paidMotivationDescriptionLabel.text = text
    }

    func setTimeMotivationTitle(text: String) {
        timeMotivationTitleLabel.text = text
    }

    func setTimeMotivationDescription(text: String) {
        timeMotivationtDescriptionLabel.text = text
    }

    func setMainButtonTitle(text: String) {
        mainButton.setTitle(text, for: .normal)
    }
}
