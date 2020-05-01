//
//  MotivationalItem.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

enum MotivationalItem: String {
    case ad = "0"
    case level1 = "1"
    case level2 = "2"
    case level3 = "3"
    case level4 = "4"
    case level5 = "5"
    
    init?(index: Int) {
        guard let item = MotivationalItem(rawValue: String(index)) else {
            return nil
        }
        
        self = item
    }
    
    var title: String {
        switch self {
        case .ad: return Strings.motivationItemAdTitle()
        case .level1: return Strings.motivationItemLevel1Title()
        case .level2: return Strings.motivationItemLevel2Title()
        case .level3: return Strings.motivationItemLevel3Title()
        case .level4: return Strings.motivationItemLevel4Title()
        case .level5: return Strings.motivationItemLevel5Title()
        }
    }
    
    var image: UIImage {
        switch self {
        case .ad: return R.image.ad_icon()!
        case .level1: return R.image.cuddly_cat()!
        case .level2: return R.image.fluffy_cat()!
        case .level3: return R.image.tilda_cat()!
        case .level4: return R.image.pinko_cat()!
        case .level5: return R.image.valli_cat()!
        }
    }
    
    var descriptionTitle: String {
        Strings.motivationItemDescriptionTitle()
    }
    
    var description: String {
        switch self {
        case .ad: return Strings.motivationItemDescriptionAd()
        default: return Strings.motivationItemDescriptionCat()
        }
    }
}
