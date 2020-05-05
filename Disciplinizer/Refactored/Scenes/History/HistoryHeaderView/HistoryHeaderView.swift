//
//  HeaderView.swift
//  Disciplinizer
//
//  Created by Anton on 04.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

class HistoryHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private var mainView: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var todayDuration: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        Bundle.main.loadNibNamed("HistoryHeaderView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.roundCorners(corners: .all, radius: 8)
        mainView.addShadow(shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.08),
                                 offSet: CGSize(width: 0, height: 4),
                                 opacity: 1,
                                 shadowRadius: 10)
        
        dateLabel.text = "test"
        todayDuration.text = "test"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
