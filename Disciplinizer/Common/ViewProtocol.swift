//
//  ViewProtocol.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 01/09/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol ViewProtocol: class { }

extension ViewProtocol {
    var router: RouterProtocol? {
        guard let controller = self as? UIViewController else { return nil }

        return Router(initialController: controller)
    }
}
