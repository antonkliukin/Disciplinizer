//
//  Challenge.swift
//  DisciplinizerTests
//
//  Created by Anton Kliukin on 08.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation
@testable import Disciplinizer

extension Challenge {
    static func createArray(numberOfElements: Int = 2) -> [Challenge] {
        var challenges: [Challenge] = []

        for index in 0..<numberOfElements {
            let challenge = createChallenge(index: index)
            challenges.append(challenge)
        }

        return challenges
    }

    static func createChallenge(index: Int = 0) -> Challenge {
        Challenge(id: String(index),
                  startDate: Date(),
                  finishDate: nil,
                  duration: 100,
                  isSuccess: true,
                  isPaid: false,
                  betId: nil)
    }
}
