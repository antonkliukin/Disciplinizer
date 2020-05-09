//
//  SettingsCollectionView.swift
//  Disciplinizer
//
//  Created by Anton on 09.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

final class SettingsCollectionView: CollectionView<SettingsCell, SettingsSectionItem> {

    init(sections: [[SettingsSectionItem]]) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

        super.init(sections: sections, layout: layout, cellReuseIdentifier: .identifier(SettingsCell.id)) { (cell, model, _) in
            cell.configure(model)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SettingsSectionHeader", for: indexPath) as? SettingsSectionHeader {
            let title = SettingsSectionItem.headerTitle(forIndexPath: indexPath)
            header.titleLabel.text = title
            return header
        }
        
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: flowLayout.itemSize.width, height: 40)
    }
}

