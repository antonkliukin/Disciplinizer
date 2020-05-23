//
//  GuideModeSelecionView.swift
//  Disciplinizer
//
//  Created by Anton on 09.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

enum GuideModeSelecionViewState {
    case selected, unselected
}

class GuideModeSelecionView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var modeTitleLabel: UILabel!
    @IBOutlet weak var modeDescriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
        
    private func commonInit() {
        Bundle.main.loadNibNamed("GuideModeSelecionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        contentView.roundCorners(corners: .all, radius: 16)
        contentView.layer.borderColor = R.color.lightBlue()!.withAlphaComponent(0.5).cgColor
        
        iconView.roundCorners(corners: .all, radius: iconView.bounds.size.width / 2)
        iconView.backgroundColor = .clear
        iconView.layer.borderWidth = 2
        
        changeState(.unselected)
    }
    
    func changeState(_ state: GuideModeSelecionViewState) {
        switch state {
        case .selected:
            contentView.backgroundColor = R.color.lightBlue()!
            contentView.layer.borderWidth = 0
            iconView.layer.borderColor = UIColor.white.cgColor
            modeTitleLabel.textColor = .white
            modeDescriptionLabel.textColor = .white
            iconImageView.alpha = 1
        case .unselected:
            contentView.backgroundColor = .white
            contentView.layer.borderWidth = 2
            iconView.layer.borderColor = R.color.lightBlue()!.withAlphaComponent(0.5).cgColor
            modeTitleLabel.textColor = R.color.lightBlue()!
            modeDescriptionLabel.textColor = R.color.lightBlue()!
            iconImageView.alpha = 0.5
        }
    }
    
    func configure(title: String, description: String, image: UIImage) {
        modeTitleLabel.text = title
        modeDescriptionLabel.text = description
        iconImageView.image = image
    }
}
