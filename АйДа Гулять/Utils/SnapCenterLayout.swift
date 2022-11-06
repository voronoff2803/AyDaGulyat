//
//  SnapCenterLayout.swift
//  Example
//
//  Created by Alex Kerendian on 8/11/19.
//  Copyright © 2019 Alexander Kerendian. All rights reserved.
//

import Foundation
import UIKit


class SnapCenterLayout: UICollectionViewFlowLayout {
    var isLastUnreachable: Bool
    
    init(isLastUnreachable: Bool = false) {
        self.isLastUnreachable = isLastUnreachable
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        let parent = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        
        let itemSpace = itemSize.width + minimumInteritemSpacing
        var currentItemIdx = round(collectionView.contentOffset.x / itemSpace)
        
        let vX = velocity.x
        if vX > 0 {
            currentItemIdx += 1
        } else if vX < 0 {
            currentItemIdx -= 1
        }
        
        if currentItemIdx < 0 {
            currentItemIdx = 0
        }
        
        let count = CGFloat(collectionView.numberOfItems(inSection: 0))
        
        if currentItemIdx >= (isLastUnreachable ? count - 1 : count) {
            currentItemIdx = count - (isLastUnreachable ? 2 : 1)
        }
        
        let nearestPageOffset = currentItemIdx * itemSpace + sectionInset.left - ((collectionView.frame.width - itemSize.width) / 2)
        
        return CGPoint(x: nearestPageOffset,
                       y: parent.y)
    }
}
