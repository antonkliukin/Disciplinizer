//
//  SettingsSection.swift
//  Disciplinizer
//
//  Created by Anton on 09.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

enum ActionViewType {
    case tap
    case switcher(isOn: Bool)
}

struct SettingsSectionItem {
    var title = ""
    var action: (Bool) -> Void = { _ in }
    var actionViewType: ActionViewType = .tap
    
    static func headerTitle(forIndexPath indexPath: IndexPath) -> String {
        switch indexPath.section {
        case 0: return Strings.settingsNotifications()
        case 1: return Strings.settingsAppearance()
        case 2: return Strings.settingsGetInTouch()
        case 3: return Strings.settingsAbout()
        default: return ""
        }
    }
}
