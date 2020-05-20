//
//  LaunchScreenView.swift
//  Disciplinizer
//
//  Created by Anton on 20.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

final class LaunchScreenView: UIView {
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(LaunchScreenView.nameOfClass, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
