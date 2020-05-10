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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for dotView in messageView.dotsStack.arrangedSubviews {
            dotView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func configure(_ message: String) {
        messageView.messageLabel.text = message
    }
}
