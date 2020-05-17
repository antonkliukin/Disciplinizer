//
//  ChatCell.swift
//  Disciplinizer
//
//  Created by Anton on 10.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

final class ChatCell: UICollectionViewCell {
    static let id = "ChatCell"
    
    @IBOutlet weak var messageView: GuideMessageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
        
    func configure(_ message: String) {
        messageView.messageLabel.text = message
    }
}
