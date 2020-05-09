//
//  UserDefaultsError.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

struct UserDefaultsError: Error {
    var localizedDescription: String {
        return message
    }

    var message = ""
}
