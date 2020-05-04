//
//  Challenge.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.02.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

struct Challenge {
    var id: String
    var startDate: Date?
    var finishDate: Date?
    var duration: Int
    var isSuccess: Bool
    var motivationalItem: MotivationalItem
}

extension Challenge: Equatable { }

func == (lhs: Challenge, rhs: Challenge) -> Bool {
    return lhs.id == rhs.id
}

enum ChallengeResult {
    case win
    case lose
}

enum ChallengeMode {
    case free
    case paid
}
