//
//  StackCollectionViewLayout.swift
//  Disciplinizer
//
//  Created by Anton on 01.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

class StackCollectionViewLayout: UICollectionViewFlowLayout {
    private let topInset: CGFloat = 50
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)?.compactMap { $0.copy() as? UICollectionViewLayoutAttributes }.compactMap(addStackAnimationToAttributes)
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let verticalOffset = proposedContentOffset.y
        let targetRect = CGRect(origin: CGPoint(x: 0, y: proposedContentOffset.y), size: self.collectionView!.bounds.size)

        for layoutAttributes in super.layoutAttributesForElements(in: targetRect)! {
            let itemOffset = layoutAttributes.frame.origin.y
            if (abs(itemOffset - verticalOffset) < abs(offsetAdjustment)) {
                offsetAdjustment = itemOffset - verticalOffset
            }
        }
        
        return CGPoint(x: proposedContentOffset.x, y: proposedContentOffset.y + offsetAdjustment - topInset)
    }
    
    
    private func addStackAnimationToAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        
        let contentOffset = collectionView.contentOffset
        let cellHeight: CGFloat = attributes.frame.height
        let cellTopSpace = contentOffset.y - (cellHeight * CGFloat(attributes.indexPath.row))
        
        if cellTopSpace >= 0 {
            attributes.frame.origin.y += cellTopSpace
        }
        
        let scaleFactor: CGFloat = 1 - abs(cellTopSpace / (cellHeight * 4.5))
        attributes.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        attributes.alpha = 1 - abs(cellTopSpace / (cellHeight * 2))
        
        let nextCellTopSpace = contentOffset.y - (cellHeight * CGFloat(attributes.indexPath.row + 1))
        let liftCellToTopRate: CGFloat = topInset - abs(nextCellTopSpace) / (cellHeight / topInset)
        
        if nextCellTopSpace + cellHeight > 0 {
            if nextCellTopSpace >= 0 {
                // Cell is behind
                attributes.frame.origin.y -= topInset
            } else {
                // Cell is going up
                attributes.frame.origin.y -= min(topInset, liftCellToTopRate)
            }
        } else if nextCellTopSpace + cellHeight < 0 {
             // Cell is going down
            if liftCellToTopRate > 0 {
                attributes.frame.origin.y += liftCellToTopRate
            }
        }
        
        attributes.zIndex = attributes.indexPath.row
        
        return attributes
    }
}
