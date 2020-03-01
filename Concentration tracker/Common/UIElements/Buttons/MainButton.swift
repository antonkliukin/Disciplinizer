//
//  MainButton.swift
//  Concentration tracker
//
//  Created by Lucky Iyinbor on 25.09.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import UIKit

private struct Constants {
    static let cornerRaduis: CGFloat = 8
}

class MainButton: UIButton {
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.4)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.6)
        gradientLayer.colors = [R.color.ctPurple()!.cgColor, R.color.ctBlue()!.cgColor]
        gradientLayer.cornerRadius = Constants.cornerRaduis
        
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.first?.frame = self.bounds
        self.layer.sublayers?.filter ({ $0.isKind(of: CAGradientLayer.self) }).first?.frame = self.bounds
    }
    
    @objc private func configureDownState() {
        self.alpha = 0.5
    }
    
    private func configure() {
        self.alpha = isEnabled ? 1 : 0.5
        self.backgroundColor = .clear
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.text = "Start"
        self.titleLabel?.font = R.font.museoSans700(size: 20)
        self.layer.cornerRadius = Constants.cornerRaduis
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.addShadowLayer()
    }
    
    private func addShadowLayer() {
        let frame = self.bounds
        let shadowView = UIView(frame: frame)
        shadowView.isUserInteractionEnabled = false
        shadowView.backgroundColor = .white
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        shadowView.layer.shadowColor = R.color.ctPurple()!.cgColor
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowRadius = 8
        shadowView.layer.cornerRadius = Constants.cornerRaduis
        
        self.insertSubview(shadowView, at: 0)
    }
}
