//
//  CALayer+Extension.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 23.10.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(radius: CGFloat = 3, opacity: Float = 0.2) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    func roundCorners(radius: CGFloat = 7) {
        layer.cornerRadius = radius
    }
}
