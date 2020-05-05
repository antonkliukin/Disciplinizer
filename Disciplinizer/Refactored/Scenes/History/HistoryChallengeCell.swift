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
    func setResultTextColor(color: UIColor)
    func display(duration: String)
    func display(timePeriod: String)
    func display(motivationType: String)
}

final class HistoryChallengeCell: UITableViewCell, HistoryChallengeCellViewProtocol {
    @IBOutlet weak var mainCellView: UIView!
    @IBOutlet private weak var challengeResultTitleLabel: UILabel!
    @IBOutlet private weak var durationTitleLabel: UILabel!
    @IBOutlet weak var challengeTimePeriodTitle: UILabel!
    @IBOutlet weak var modeTitleLabel: UILabel!
    
    static var reuseId = "ChallengeCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainCellView.roundCorners(corners: .all, radius: 8)
        mainCellView.addShadow(shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.08),
                                 offSet: CGSize(width: 0, height: 4),
                                 opacity: 1,
                                 shadowRadius: 10)
    }

    func display(result: String) {
        challengeResultTitleLabel.text = result
    }
    
    func setResultTextColor(color: UIColor) {
        challengeResultTitleLabel.textColor = color
    }

    func display(duration: String) {
        durationTitleLabel.text = duration
    }
    
    func display(timePeriod: String) {
        challengeTimePeriodTitle.text = timePeriod
    }

    func display(motivationType: String) {
        modeTitleLabel.text = motivationType
    }
    
    @IBAction func didTapDeleteButton(_ sender: Any) {
        
    }
}
