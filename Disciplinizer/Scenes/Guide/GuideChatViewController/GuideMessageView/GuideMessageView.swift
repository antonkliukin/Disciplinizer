//
//  GuideMessageView.swift
//  Disciplinizer
//
//  Created by Anton on 10.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

enum GuideMessageViewState {
    case sticker, text
}

class GuideMessageView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var stickerImageView: UIImageView!
    
    @IBOutlet weak var messageBackgroundView: UIView!
    
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
                
        changeState(.text)
    }
    
    func changeState(_ state: GuideMessageViewState) {
        switch state {
        case .text:
            messageLabel.isHidden = false
            messageBackgroundView.isHidden = false
            stickerImageView.isHidden = true
        case .sticker:
            messageLabel.isHidden = true
            messageBackgroundView.isHidden = true
            stickerImageView.isHidden = false
        }
    }
}
