//
//  PagingCollectionViewLayout.swift
//  Example
//
//  Created by Alex Kerendian on 8/11/19.
//  Copyright © 2019 Alexander Kerendian. All rights reserved.
//

import Foundation
import UIKit

class PagingCollectionViewLayout: UICollectionViewFlowLayout
{
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint
    {
        if let collectionViewBounds = self.collectionView?.bounds
        {
            let halfWidthOfVC = collectionViewBounds.size.width * 0.5
            let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidthOfVC
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: collectionViewBounds) {
                var candidateAttribute : UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    if attributes.indexPath.row == 0 { continue }
                    if attributes.indexPath.row + 1 == collectionView?.numberOfItems(inSection: 0) { continue }
                    let candAttr : UICollectionViewLayoutAttributes? = candidateAttribute
                    if candAttr != nil {
                        let a = attributes.center.x - proposedContentOffsetCenterX
                        let b = candAttr!.center.x - proposedContentOffsetCenterX
                        if abs(a) < abs(b) {
                            candidateAttribute = attributes
                        }
                    } else {
                        candidateAttribute = attributes
                        continue
                    }
                }
                
                if candidateAttribute != nil {
                    return CGPoint(x: candidateAttribute!.center.x - halfWidthOfVC, y: proposedContentOffset.y);
                }
            }
        }
        return CGPoint.zero
    }
}
