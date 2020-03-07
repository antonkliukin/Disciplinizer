//
//  PageCell.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 19.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

final class PageCell: UICollectionViewCell {
    static let reuseId = "PageCell"
    
    var hostedView: UIView? {
        didSet {
            guard let hostedView = hostedView else {
                return
            }

            contentView.addSubview(hostedView)
            hostedView.frame = contentView.bounds
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        if hostedView?.superview == contentView { //Make sure that hostedView hasn't been added as a subview to a different cell
            hostedView?.removeFromSuperview()
        }

        hostedView = nil
    }
}
