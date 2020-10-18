//
//  NSObject+NameOfClass.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 25/08/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

extension NSObject {
    static var nameOfClass: String {
        return String(describing: self)
    }
}
