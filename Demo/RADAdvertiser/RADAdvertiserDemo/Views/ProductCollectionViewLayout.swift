//
//  ProductCollectionViewLayout.swift
//  RADAdvertiserDemo
//
//  Created by Durbalo, Andrii on 13.04.2020.
//  Copyright © 2020 Rakuten Advertising. All rights reserved.
//

import Foundation
import UIKit

class ProductCollectionViewLayout: UICollectionViewLayout {
    
    //MARK: - properties
    
    private var cache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        return collectionView?.bounds.width ?? 0
    }
    
    private var itemHeight: CGFloat {
        return contentWidth / 2
    }
    
    private var itemWidth: CGFloat {
        return contentWidth / 2
    }
    
    //MARK: - override
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        configureBaseLayout()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.values.filter { return $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath]
    }
    
    //MARK: - private
    
    private func configureBaseLayout() {
        
        guard let collectionView = collectionView else {
            return
        }
        
        cache.removeAll()

        var yOffset: CGFloat = 0
        
        for section in 0 ..< collectionView.numberOfSections {
            
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                
                let indexPath = IndexPath(item: item, section: section)
                
                let x = item % 2 == 0 ? 0 : itemWidth
                let frame = CGRect(x: x, y: yOffset, width: itemWidth, height: itemHeight)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                
                cache[indexPath] = attributes
                contentHeight = frame.maxY
                yOffset +=  item % 2 == 0 ? 0 : itemHeight
            }
        }
    }
}
