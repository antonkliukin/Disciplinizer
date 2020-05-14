//
//  RootViewController.swift
//  Disciplinizer
//
//  Created by Anton on 14.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

var rootVC = RootViewController()

class RootViewController: UIViewController {
    private var stubView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootVC.add(Controller.createPageNavigation())
        
        stubView.backgroundColor = .white
        stubView.frame = view.frame
        view.addSubview(stubView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isFirstLaunchStampExist = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunchStampExist == false {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            present(Controller.guideChat(), animated: false, completion: {
                self.stubView.removeFromSuperview()
            })
        } else {
            self.stubView.removeFromSuperview()
        }
    }
}
