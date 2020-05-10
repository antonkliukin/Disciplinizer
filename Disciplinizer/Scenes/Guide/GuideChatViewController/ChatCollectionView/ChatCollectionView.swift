//
//  ChatCollectionView.swift
//  Disciplinizer
//
//  Created by Anton on 10.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

struct ChatMessage {
    var text = ""
}

final class ChatCollectionView: CollectionView<ChatCell, ChatMessage> {
    
    init(sections: [[ChatMessage]]) {
        let layout = UICollectionViewFlowLayout()
        
        super.init(sections: sections, layout: layout, cellReuseIdentifier: .identifier(ChatCell.id)) { (cell, model, indexPath, numberOfItemsInSection) in
            cell.configure(model.text)
            cell.messageView.changeState(model.text.isEmpty ? .inProgress : .text)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
