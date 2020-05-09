//
//  CoreDataError.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 08.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

struct CoreError: Error {
    var localizedDescription: String {
        return message
    }

    var message = ""
}
