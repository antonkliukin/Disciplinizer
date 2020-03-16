//
//  MotivationalItem.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

enum MotivationalItem: String {
    case ad = "0"
    case tinyCoin = "1"
    case smallCoin = "2"
    case mediumCoin = "3"
    case bigCoin = "4"
    case hugeCoin = "5"

    var title: String {
        switch self {
        case .ad: return Strings.motivationItemAd()
        case .tinyCoin: return Strings.motivationItemTinyCoin()
        case .smallCoin: return Strings.motivationItemSmallCoin()
        case .mediumCoin: return Strings.motivationItemMediumCoin()
        case .bigCoin: return Strings.motivationItemBigCoin()
        case .hugeCoin: return Strings.motivationItemHugeCoin()
        }
    }
}
