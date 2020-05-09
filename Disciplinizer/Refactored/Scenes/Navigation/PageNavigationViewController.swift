//
//  PageNavigationViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 17.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol PageNavigationViewProtocol: ViewProtocol {

}

final class PageNavigationViewController: UITabBarController, PageNavigationViewProtocol {
    var presenter: PageNavigationPresenterProtocol?
    var controllers: [UIViewController] = []

    private let configurator = PageNavigationConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers(controllers, animated: false)
        selectTab(withIndex: 1)
        setupTabBarItems()

        configurator.configure(pageNavigationViewController: self)
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear()
    }
    
    override var selectedViewController: UIViewController? {
        didSet {
            updateTabBarItems()
        }
    }
    
    private func updateTabBarItems() {
        guard let viewControllers = viewControllers else {
            return
        }
        
        for vc in viewControllers {
            if vc == selectedViewController {
                vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .bold)], for: .normal)
            } else {
                vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .regular)], for: .normal)
            }
        }
    }

    private func selectTab(withIndex index: Int) {
        selectedIndex = index
    }

    private func setupTabBarItems() {
        tabBar.tintColor = R.color.navigationItemSelected()
        
        setupTabBarImages()
        
        updateTabBarItems()
    }
    
    private func setupTabBarImages() {
        for (index, item) in (tabBar.items ?? []).enumerated() {
            switch index {
            case 0: item.image = R.image.history_icon()
            case 1: item.image = R.image.tracker_icon()
            case 2: item.image = R.image.settings_icon()
            default:
                break
            }
        }
    }
}
