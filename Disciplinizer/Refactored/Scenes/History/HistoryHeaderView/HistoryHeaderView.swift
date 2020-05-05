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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todayDuration: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .white
                
        mainView.roundCorners(corners: .all, radius: 8)
        mainView.addShadow(shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.1),
                                 offSet: CGSize(width: 0, height: 4),
                                 opacity: 1,
                                 shadowRadius: 10)
    }
}
