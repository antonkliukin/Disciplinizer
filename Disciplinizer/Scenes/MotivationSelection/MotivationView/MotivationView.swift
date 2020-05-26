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
    @IBOutlet weak var motivationTitleBackgroundView: UIView!
    @IBOutlet weak var motivationTitleLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var motivationDescriptionTitle: UILabel!
    @IBOutlet weak var motivationDescription: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
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
        Bundle.main.loadNibNamed(Self.nameOfClass, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        actionButton.configure(withStyle: .secondary)
        
        setupMainView()
        setupMotivationTitleLabel()
    }
    
    func configure(withItem item: MotivationalItem, didTapActionButton: (() -> Void)?) {
        motivationTitleBackgroundView.isHidden = item.title.isEmpty
        motivationTitleLabel.isHidden = item.title.isEmpty
        motivationTitleLabel.text = item.title
                
        infoLabel.isHidden = item.info.isEmpty
        infoLabel.text = item.info
        infoLabel.textColor = item.title.isEmpty ? R.color.redText() : R.color.greenText()!
        
        actionButton.isHidden = item.actionTitle.isEmpty
        actionButton.setTitle(item.actionTitle, for: .normal)
        action = didTapActionButton
        
        infoLabelActionButtonConstraint.priority = item.actionTitle.isEmpty ? .defaultLow : .defaultHigh
        infoLabelMainViewConstraint.priority = item.actionTitle.isEmpty ? .defaultHigh : .defaultLow
        
        itemImageView.image = item.image
        motivationDescriptionTitle.text = item.descriptionTitle
        motivationDescription.text = item.description
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
        motivationTitleBackgroundView.roundCorners(radius: motivationTitleBackgroundView.bounds.size.height / 2)
    }
}
