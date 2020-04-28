//
//  MotivationView.swift
//  Disciplinizer
//
//  Created by Anton on 27.04.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

enum MotivationViewState {
    case cat
    case noCat
    case ad
}

class MotivationView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var motivationTitleLabel: UILabel!
    @IBOutlet weak var actionButton: MainButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoLabelActionButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoLabelMainViewConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
        
    private func commonInit() {
        Bundle.main.loadNibNamed("MotivationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        actionButton.configure(withStyle: .secondary)
        
        setupMainView()
        setupMotivationTitleLabel()
    }
        
    private func setupMainView() {
        mainView.addShadow()
        mainView.roundCorners()
    }
    
    private func setupMotivationTitleLabel() {
        motivationTitleLabel.roundCorners(radius: motivationTitleLabel.bounds.size.height / 2)
    }
}
