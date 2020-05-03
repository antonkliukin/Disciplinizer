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
        
        catMotivationView.mainView.layer.borderWidth = 2
        catMotivationView.mainView.layer.borderColor = R.color.darkBlueText()!.cgColor
        catMotivationView.mainView.roundCorners(corners: .all, radius: 16)
    }
}
