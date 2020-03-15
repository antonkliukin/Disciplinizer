//
//  ChallengeCell.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 01.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol HistoryChallengeCellViewProtocol {
    func display(result: String)
    func display(duration: String)
    func display(motivationType: String)
}

final class HistoryChallengeCell: UITableViewCell, HistoryChallengeCellViewProtocol {
    @IBOutlet private weak var resultTitle: UILabel!
    @IBOutlet private weak var durationTitle: UILabel!
    @IBOutlet private weak var motivationTypeTitle: UILabel!

    static var reuseId = "challengeCellId"

    func display(result: String) {
        resultTitle.text = result
    }

    func display(duration: String) {
        durationTitle.text = duration
    }

    func display(motivationType: String) {
        motivationTypeTitle.text = motivationType
    }
}
