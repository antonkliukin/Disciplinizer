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
        let layout = SideAnimationCollectionViewLayout()
        
        super.init(sections: sections, layout: layout, cellReuseIdentifier: .identifier(ChatCell.id)) { (cell, model, indexPath, numberOfItemsInSection) in
            cell.configure(model.text)
            cell.messageView.changeState(model.text == "catSticker" ? .sticker : .text)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 110
        let verticalPadding: CGFloat = 30
        
        let text = sections[0][indexPath.item].text
        
        if text == "catSticker" {
            return CGSize(width: flowLayout.itemSize.width, height: 130)
        } else {
            let horizontalPadding: CGFloat = 65
            let size = CGSize(width: flowLayout.itemSize.width - horizontalPadding, height: flowLayout.itemSize.height - 20)

            height = text.estimateFrameForText(ofFont: UIFont.systemFont(ofSize: 15), inRect: size).height + verticalPadding

            return CGSize(width: flowLayout.itemSize.width, height: height)
        }
    }    
}

final class SideAnimationCollectionViewLayout: UICollectionViewFlowLayout {
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = layoutAttributesForItem(at: itemIndexPath)
        
        attributes?.frame.origin.x -= attributes?.frame.width ?? 0
        
        return attributes
    }
}
