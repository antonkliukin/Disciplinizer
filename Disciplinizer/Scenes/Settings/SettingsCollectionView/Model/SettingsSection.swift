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
    var sectionTitle = ""
    var title = ""
    var action: (Bool) -> Void = { _ in }
    var actionViewType: ActionViewType = .tap
}
