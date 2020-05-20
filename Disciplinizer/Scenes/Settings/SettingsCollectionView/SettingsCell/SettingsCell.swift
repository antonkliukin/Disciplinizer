//
//  SettingsCell.swift
//  Disciplinizer
//
//  Created by Anton on 09.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

final class SettingsCell: UICollectionViewCell {
    static let id = "SettingsCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    private var model: SettingsSectionItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.roundCorners(corners: .all, radius: 8)
        
        addShadow()
        clipsToBounds = false
    }
    
    func configure(_ model: SettingsSectionItem) {
        self.model = model
        switcher.isHidden = true
        
        titleLabel.text = model.title
        switch model.actionViewType {
        case .switcher(let isOn):
            switcher.isHidden = false
            switcher.isOn = isOn
        case .tap:
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapAction))
            contentView.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func handleTapAction() {
        model?.action(true)
    }
    
    @IBAction func switcherDidChange(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            model?.action(switcher.isOn)
        }
    }
}
