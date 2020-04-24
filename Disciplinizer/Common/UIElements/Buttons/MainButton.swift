//
//  MainButton.swift
//  Disciplinizer
//
//  Created by Lucky Iyinbor on 25.09.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

private struct Constants {
    static let cornerRaduis: CGFloat = 8
}

class MainButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    @objc private func configureDownState() {
        self.alpha = 0.5
    }
    
    private func configure() {
        self.alpha = isEnabled ? 1 : 0.5
        self.backgroundColor = .gray
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.layer.cornerRadius = Constants.cornerRaduis
        setTitleColor(.white, for: .normal)
    }
}
