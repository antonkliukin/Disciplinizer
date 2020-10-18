//
//  CDMotivationalItem.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 04.10.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import CoreData

extension CDMotivationalItem {
    var motivationalItem: MotivationalItemConfig {
        return MotivationalItemConfig(id: id ?? "",
                                      title: title ?? "",
                                      description: desc ?? "",
                                      avatarURL: avatarURL,
                                      imageURL: imageURL)
    }
    
    func pupulate(with motivationalItem: MotivationalItemConfig) {
        id = motivationalItem.id
        title = motivationalItem.title
        desc = motivationalItem.description
        avatarURL = motivationalItem.avatarURL
        imageURL = motivationalItem.imageURL
    }
}
