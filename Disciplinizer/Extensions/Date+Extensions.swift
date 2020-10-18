//
//  Date+Extensions.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 27.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.string(from: self)
    }

    func currentTimeMillis() -> Int {
        return Int(self.timeIntervalSince1970 * 1000)
    }
}

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateFormatter.date(from: self)
    }
}
