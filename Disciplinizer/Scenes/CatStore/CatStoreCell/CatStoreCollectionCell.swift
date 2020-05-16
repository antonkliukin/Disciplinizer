//
//  CatStoreCollectionCell.swift
//  Disciplinizer
//
//  Created by Anton on 01.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

class CatStoreCollectionCell: UICollectionViewCell {
    @IBOutlet weak var catMotivationView: MotivationView!
    
    static let id = "CatStoreCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        catMotivationView.mainView.roundCorners(corners: .all, radius: 16)
        showBorder(false)
    }
    
    func showBorder(_ show: Bool) {
        catMotivationView.mainView.layer.borderWidth = show ? 2 : 0
        catMotivationView.mainView.layer.borderColor = R.color.darkBlueText()!.cgColor
    }
}
