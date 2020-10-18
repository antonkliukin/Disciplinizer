//
//  PageCollectionViewCell.swift
//  Onboarding
//
//  Created by Anton Kliukin on 09/03/2019.
//  Copyright © 2019 CJSC SberTech. All rights reserved.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    static let reuseId = nameOfClass
    
    func configure(with title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
    }
}
