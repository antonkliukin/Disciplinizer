//
//  MotivationalItem.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

enum MotivationalItem: String, CaseIterable {
    case noPaidItem = "-1"
    case ad = "0"
    case level1 = "1"
    case level2 = "2"
    case level3 = "3"
    case level4 = "4"
    case level5 = "5"
        
    static var allCats: [MotivationalItem] {
        allCases.filter { $0 != .ad && $0 != .noPaidItem }
    }
    
    var title: String {
        switch self {
        case .noPaidItem: return ""
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
        case .noPaidItem: return R.image.no_cat()!
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
        
    var actionTitle: String {
        switch self {
        case .noPaidItem: return Strings.motivationItemActionTitle()
        default: return ""
        }
    }
    
    var info: String {
        switch self {
        case .noPaidItem: return Strings.motivationItemInfoNotCat()
        case .ad: return ""
        default: return Strings.motivationItemInfoHaveCat()
        }
    }
    
    var color: UIColor {
        switch self {
        case .level1: return R.color.lightBlueCat()!
        case .level2: return R.color.lightOrangeCat()!
        case .level3: return R.color.greyCat()!
        case .level4: return R.color.brownCat()!
        case .level5: return R.color.pinkCat()!
        default: return R.color.lightBlueCat()!
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .level1: return R.color.darkBlueText()!
        case .level2: return R.color.darkOrange()!
        default: return .white
        }
    }
    
    var price: StoreProductPrice {
        switch self {
        case .level1: return .oneDollar
        case .level2: return .twoDollars
        case .level3: return .threeDollars
        case .level4: return .fourDollars
        case .level5: return .fiveDollars
        default: return .fiveDollars
        }
    }
    
    var priceColor: UIColor {
        switch self {
        case .level1: return R.color.darkBlueText()!
        default: return color
        }
    }
}
