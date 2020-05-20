//
//  UIView+Extension.swift
//  Disciplinizer
//
//  Created by Anton on 25.04.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow(color: UIColor = .black,
                   alpha: Float = 0.08,
                   x: CGFloat = 0,
                   y: CGFloat = 4,
                   blur: CGFloat = 15,
                   spread: CGFloat = 0) {
        
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / UIScreen.main.scale
        
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func roundCorners(corners: ViewCorners = .all,
                      radius: CGFloat = 7) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners.caCorner
    }
}

enum ViewCorners {
    case all, top, bottom
}

extension ViewCorners {
    var caCorner: CACornerMask {
        switch self {
        case .top:
            return [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        case .bottom:
            return [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        default:
            return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
}
