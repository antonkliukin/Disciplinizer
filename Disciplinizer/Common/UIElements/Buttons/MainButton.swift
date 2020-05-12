//
//  MainButton.swift
//  Disciplinizer
//
//  Created by Lucky Iyinbor on 25.09.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

enum MainButtonStyle {
    case main, secondary
}

class MainButton: UIButton {
    
    override var backgroundColor: UIColor? {
        didSet {
            print(backgroundColor)
        }
    }
    
    var style: MainButtonStyle = .main
    var isResponsive: Bool = false {
        didSet {
            DispatchQueue.main.async {
                switch self.style {
                case .main:
                    self.backgroundColor = self.isResponsive ? R.color.lightBlue() : R.color.buttonGrey()
                case .secondary:
                    self.backgroundColor = self.isResponsive ? R.color.lightGrey() : R.color.lightGrey()
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure(withStyle style: MainButtonStyle = .main) {
        self.style = style
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        roundCorners(corners: .all, radius: 16)
        
        switch style {
        case .main:
            self.backgroundColor = R.color.lightBlue()
            setTitleColor(.white, for: .normal)
        case .secondary:
            self.backgroundColor = R.color.lightGrey()
            setTitleColor(.black, for: .normal)
        }
    }
}
