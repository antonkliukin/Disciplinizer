//
//  UIView+Extension.swift
//  Disciplinizer
//
//  Created by Anton on 25.04.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow(shadowColor: UIColor = .black,
                   offSet: CGSize = CGSize(width: 0, height: 4),
                   opacity: Float = 0.2,
                   shadowRadius: CGFloat = 5) {
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = offSet
        layer.shadowOpacity = opacity
        layer.shadowRadius = shadowRadius
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
