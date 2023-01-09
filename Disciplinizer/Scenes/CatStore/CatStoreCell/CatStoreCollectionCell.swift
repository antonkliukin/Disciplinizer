//
//  CatStoreCollectionCell.swift
//  Disciplinizer
//
//  Created by Anton on 01.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

class CatStoreCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var catImageView: UIImageView!
    @IBOutlet private weak var buyButton: MainButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleLabelBackgroundView: UIView!
    
    static let id = "CatStoreCell"
    
    private var action: () -> Void = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.roundCorners(corners: .all, radius: 16)
        mainView.addShadow()
        titleLabelBackgroundView.roundCorners(corners: .all, radius: titleLabelBackgroundView.bounds.height / 2)
        
        showBorder(false)
    }
    
    func showBorder(_ show: Bool) {
        mainView.layer.borderWidth = show ? 2 : 0
        mainView.layer.borderColor = R.color.darkBlueText()!.cgColor
    }
    
    func configure(withItem item: MotivationalItem, onBuyButtonTap: @escaping () -> Void) {
        priceLabel.text = item.price.localizedPrice
        priceLabel.textColor = item.priceColor
        
        catImageView.image = item.image
        
        buyButton.setTitle(R.string.localizable.buyAction(), for: .normal)
        buyButton.backgroundColor = item.color
        buyButton.setTitleColor(item.textColor, for: .normal)
        
        titleLabel.text = item.title
        titleLabel.textColor = item.textColor
        
        titleLabelBackgroundView.backgroundColor = item.color
        
        action = onBuyButtonTap
    }
    
    @IBAction func didTapBuyButton(_ sender: Any) {
        action()
    }
}
