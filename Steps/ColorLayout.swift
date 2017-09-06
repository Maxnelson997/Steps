//
//  ColorLayout.swift
//  Steps
//
//  Created by Max Nelson on 9/1/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class ColorLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.minimumLineSpacing = 5
        self.sectionFootersPinToVisibleBounds = true
        self.sectionHeadersPinToVisibleBounds = true
        self.scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var insertingIndexPaths = [IndexPath]()
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertingIndexPaths.removeAll()
        
        for update in updateItems {
            if let indexPath = update.indexPathAfterUpdate, update.updateAction == .insert {
                insertingIndexPaths.append(indexPath)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertingIndexPaths.removeAll()
    }
    
    var everyother:Bool = false
    //
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        if insertingIndexPaths.contains(itemIndexPath) {
            attributes?.alpha = 0
            attributes?.transform = CGAffineTransform(translationX: 0, y: 500)
        }
        
        return attributes
    }
    
}
