//
//  GuideMessageView.swift
//  Disciplinizer
//
//  Created by Anton on 10.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

class GuideMessageView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
        
    private func commonInit() {
        Bundle.main.loadNibNamed(GuideMessageView.nameOfClass, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
