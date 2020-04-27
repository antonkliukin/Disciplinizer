//
//  CDChallenge.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 15.02.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import CoreData

extension CDChallenge {
    var challenge: Challenge {
        return Challenge(id: id ?? "",
                         startDate: startDate,
                         finishDate: finishDate,
                         duration: Int(durationInMinutes),
                         isSuccess: isSuccess,
                         isPaid: isPaid,
                         betId: betId)
    }

    func populate(with parameters: ChallengeParameters) {
        // Normally this id should be used at some point during the sync with the API backend
        id = NSUUID().uuidString

        startDate = parameters.startDate
        finishDate = parameters.finishDate
        durationInMinutes = Int16(parameters.durationInMinutes)
        isSuccess = parameters.isSuccess
        isPaid = parameters.isPaid
        betId = parameters.betId
    }

    func pupulate(with challenge: Challenge) {
        id = challenge.id
        startDate = challenge.startDate
        finishDate = challenge.finishDate
        durationInMinutes = Int16(challenge.duration)
        isSuccess = challenge.isSuccess
        isPaid = challenge.isPaid
        betId = challenge.betId
    }
}
