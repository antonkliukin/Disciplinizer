//
//  LoadingViewController.swift
//  Disciplinizer
//
//  Created by Anton on 03.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol LoadingViewProtocol: ViewProtocol {

}

class LoadingViewController: UIViewController, LoadingViewProtocol {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: LoadingPresenterProtocol?
    let configurator = LoadingConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(loadingViewController: self)
        
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .white
        }
        
        activityIndicator.color = R.color.blueBackground()
    }
}
