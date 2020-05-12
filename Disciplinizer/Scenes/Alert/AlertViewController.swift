//
//  AlertViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 24/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit


struct AlertModel {
    var title = ""
    var message = ""
    var positiveActionTitle = ""
    var positiveAction: (() -> Void)? = nil
    var negativeActionTitle = ""
    var negativeAction: (() -> Void)? = nil
}

protocol AlertViewProtocol: ViewProtocol {
    func configure(_ alert: AlertModel)
}

class AlertViewController: UIViewController, AlertViewProtocol {
    @IBOutlet weak var titleLabel: UILabel?

    var presenter: AlertPresenterProtocol!
    var configurator: AlertConfigurator?
    
    var alertModel: AlertModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator?.configure(alert: self)
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentAlert()
    }
    
    func configure(_ alert: AlertModel) {
        alertModel = alert
    }
    
    private func presentAlert() {
        let alert = UIAlertController(title: alertModel?.title, message: alertModel?.message, preferredStyle: .alert)
        
        if let positiveTitle = alertModel?.positiveActionTitle, !positiveTitle.isEmpty {
            let action = UIAlertAction(title: positiveTitle, style: .default) { (_) in
                self.presenter.didTapPositiveAlertAction()
            }
            alert.addAction(action)
        }
        
        if let negativeTitle = alertModel?.negativeActionTitle, !negativeTitle.isEmpty {
            let action = UIAlertAction(title: negativeTitle, style: .destructive) { (_) in
                self.presenter.didTapNegativeAlertAction()
            }
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
    }
}
