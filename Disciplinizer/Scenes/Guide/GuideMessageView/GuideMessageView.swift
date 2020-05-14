//
//  GuideMessageView.swift
//  Disciplinizer
//
//  Created by Anton on 10.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

enum GuideMessageViewState {
    case inProgress, text
}

class GuideMessageView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dotsStack: UIStackView!
    @IBOutlet weak var messageBackgroundImageView: UIImageView!
    
    private var isAnimationRunning = false
        
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
            dotsStack.isHidden = true
            nameTitleLabel.isHidden = false
            messageLabel.isHidden = false
            messageBackgroundImageView.isHidden = false
        case .inProgress:
            dotsStack.isHidden = false
            nameTitleLabel.isHidden = true
            messageLabel.isHidden = true
            messageBackgroundImageView.isHidden = true
            
            startActivityViewAnimation()
            
            if !isAnimationRunning {
                
                isAnimationRunning = true
            }
        }
    }
    
    private func startActivityViewAnimation() {
        var animationDelay = 0.0
        let delayTimePoints = [0.12, 0.24, 0.36]
        
        for i in 0..<dotsStack.arrangedSubviews.count {
            let dotView = dotsStack.arrangedSubviews[i]

            animationDelay += delayTimePoints[i]
            UIView.animate(withDuration: 0.5, delay: animationDelay, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
                dotView.transform = CGAffineTransform(scaleX: 2, y: 2)
            }) 
        }
    }
}
