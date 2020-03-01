//
//  Challenge.swift
//  Concentration tracker
//
//  Created by Alexander Bakhmut on 27.09.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import RealmSwift

enum ChallengeResult {
    case win
    case lose
}

enum ChallengeMode {
    case free
    case paid
}

protocol ChallengeModelProtocol: class {
    var id: Int { get set }
    var startDate: Date { get set }
    var finishDate: Date? { get set }
    var duration: TimeInterval { get set }
    var isSuccess: Bool { get set }
    var isPaid: Bool { get set }
    var betId: String? { get set } 
}

class ChallengeRealm: Object, ChallengeModelProtocol {
    @objc dynamic var id = 0
    @objc dynamic var startDate = Date()
    @objc dynamic var finishDate: Date?
    @objc dynamic var duration: TimeInterval = 0
    @objc dynamic var isSuccess = false
    @objc dynamic var isPaid = false
    @objc dynamic var betId: String?

    convenience init(duration: TimeInterval, isPaid: Bool, startDate: Date = Date(), finishDate: Date? = nil, isSuccess: Bool = false, betId: String? = nil) {
        self.init()
        self.startDate = startDate
        self.finishDate = finishDate
        self.duration = duration
        self.isSuccess = isSuccess
        self.isPaid = isPaid
        self.betId = betId
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
