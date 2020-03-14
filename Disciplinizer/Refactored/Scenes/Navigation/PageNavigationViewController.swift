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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.viewDidAppear()
    }

    private func selectTab(withIndex index: Int) {
        selectedIndex = index
    }

    private func setupTabBarItems() {
        for item in tabBar.items ?? [] {
            item.image = UIImage(named: "bar-icon-25")
        }
    }
}
