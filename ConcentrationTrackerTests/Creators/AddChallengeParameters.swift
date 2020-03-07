//
//  AddChallengeParameters.swift
//  ConcentrationTrackerTests
//
//  Created by Anton Kliukin on 02.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation
@testable import Concentration_tracker

extension AddChallengeParameters {
    static func createParameters() -> AddChallengeParameters {
        return AddChallengeParameters(startDate: Date(),
                                      finishDate: nil,
                                      duration: 100,
                                      isSuccess: true,
                                      isPaid: false,
                                      betId: nil)
    }
}
