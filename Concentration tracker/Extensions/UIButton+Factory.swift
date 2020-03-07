//
//  UIButton+Factory.swift
//  Concentration tracker
//
//  Created by Lucky Iyinbor on 25.09.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

enum Button {
    case main
    case skip
    case details
}

extension UIButton {
    static func forType<T: UIButton>(_ type: Button) -> T {
        switch type {
        case .main:
            // swiftlint:disable:next force_cast
            return MainButton() as! T
        default:
            // swiftlint:disable:next force_cast
            return UIButton() as! T
        }
    }
}
