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
    case level1 = "1"
    case level2 = "2"
    case level3 = "3"
    case level4 = "4"
    case level5 = "5"

    var title: String {
        switch self {
        case .ad: return Strings.motivationItemAd()
        case .level1: return Strings.motivationItemLevel1()
        case .level2: return Strings.motivationItemLevel2()
        case .level3: return Strings.motivationItemLevel3()
        case .level4: return Strings.motivationItemLevel4()
        case .level5: return Strings.motivationItemLevel5()
        }
    }
}
