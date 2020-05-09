//
//  ChallengeParameterView.swift
//  Disciplinizer
//
//  Created by Anton on 25.04.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

struct ParameterViewModel {
    var title: String = ""
    var valueTitle: String = ""
    var actionTitle: String = ""
    var action: () -> Void = {}
}

final class ChallengeParameterView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var parameterTitleLabel: UILabel!
    @IBOutlet weak var parameterValueLabel: UILabel!
    @IBOutlet weak var actionTitleLabel: UILabel!
    
    private var action: (() -> Void) = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
        
    private func commonInit() {
        Bundle.main.loadNibNamed("ChallengeParameterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addTapGesture()
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.roundCorners()
        
        roundCorners()
        addShadow()
    }
        
    func configure(model: ParameterViewModel) {
        parameterTitleLabel.text = model.title
        parameterValueLabel.text = model.valueTitle
        actionTitleLabel.text = model.actionTitle
        self.action = model.action
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(doAction))
        addGestureRecognizer(tap)
    }
    
    @objc private func doAction() {
        action()
    }
}
