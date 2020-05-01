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
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var motivationDescriptionTitle: UILabel!
    @IBOutlet weak var motivationDescription: UILabel!
    @IBOutlet weak var actionButton: MainButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoLabelActionButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var infoLabelMainViewConstraint: NSLayoutConstraint!
    
    private var action: (() -> Void)?
    
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
    
    func configure(title: String = "",
                   itemImage: UIImage,
                   descriptionTitle: String,
                   description: String,
                   info: String = "",
                   actionButtonTitle: String = "",
                   actionButtonAction: @escaping () -> Void = {}) {
        motivationTitleLabel.isHidden = title.isEmpty
        motivationTitleLabel.text = title
                
        infoLabel.isHidden = info.isEmpty
        infoLabel.text = info
        infoLabel.textColor = title.isEmpty ? R.color.redText() : R.color.greenText()!
        
        actionButton.isHidden = actionButtonTitle.isEmpty
        actionButton.setTitle(actionButtonTitle, for: .normal)
        action = actionButtonAction
        
        infoLabelActionButtonConstraint.priority = actionButtonTitle.isEmpty ? .defaultLow : .defaultHigh
        infoLabelMainViewConstraint.priority = actionButtonTitle.isEmpty ? .defaultHigh : .defaultLow
        
        itemImageView.image = itemImage
        motivationDescriptionTitle.text = descriptionTitle
        motivationDescription.text = description
    }
    
    @IBAction func didTapActionButton(_ sender: Any) {
        action?()
    }
        
    private func setupMainView() {
        mainView.addShadow()
        mainView.roundCorners()
    }
    
    private func setupMotivationTitleLabel() {
        motivationTitleLabel.roundCorners(radius: motivationTitleLabel.bounds.size.height / 2)
    }
}
