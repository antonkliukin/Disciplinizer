//
//  Challenge.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 15.02.2020.
//  Copyright © 2020 FutureCompanyName. All rights reserved.
//

import Foundation

struct Challenge {
    var id: String
    var startDate: Date?
    var finishDate: Date?
    var duration: TimeInterval
    var isSuccess: Bool
    var isPaid: Bool
    var betId: String?
}
