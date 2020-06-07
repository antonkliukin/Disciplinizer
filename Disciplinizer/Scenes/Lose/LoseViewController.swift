//
//  BlockedViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 09.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol LoseViewProtocol: ViewProtocol {
    func configureLoseTitle(_ title: String)
    func configureLoseDescription(_ description: String)
    func setImage(_ image: UIImage)
    func setMainButtonTitle(_ title: String)
    func setSecondaryButtonTitle(_ title: String)
}

final class LoseViewController: UIViewController, LoseViewProtocol {
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var loseTitleLabel: UILabel!
    @IBOutlet weak var loseDescriptionLabel: UILabel!
    @IBOutlet weak var loseImageView: UIImageView!
    @IBOutlet weak var mainButton: MainButton!
    @IBOutlet weak var secondaryButton: UIButton!
    
    var presenter: LosePresenterProtocol?
    var configurator: LoseConfiguratorProtocol?

    override func viewDidLoad() {
        configurator?.configure(viewController: self)
        setupMessageView()
        presenter?.viewDidLoad()
    }

    private func setupMessageView() {
        messageView.roundCorners(corners: .all, radius: 16)
        messageView.layer.borderWidth = 2
        messageView.layer.borderColor = R.color.lightGrey()!.cgColor
    }
    
    func configureLoseTitle(_ title: String) {
        loseTitleLabel.text = title
    }
    
    func configureLoseDescription(_ description: String) {
        loseDescriptionLabel.text = description
    }
    
    func setImage(_ image: UIImage) {
        loseImageView.image = image
    }
    
    func setMainButtonTitle(_ title: String) {
        mainButton.setTitle(title, for: .normal)
    }
    
    func setSecondaryButtonTitle(_ title: String) {
        secondaryButton.setTitle(title, for: .normal)
    }

    @IBAction func mainButtonTapped(_ sender: Any) {
        presenter?.didTapMainButton()
    }
    
    @IBAction func secondaryButtonTapped(_ sender: Any) {
        presenter?.didTapSecondaryButton()
    }
}
