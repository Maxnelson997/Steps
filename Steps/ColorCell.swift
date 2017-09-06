//
//  ColorCell.swift
//  Steps
//
//  Created by Max Nelson on 9/1/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class ColorCell:UICollectionViewCell {
    
    
    var color:UIColor {
        get {
            return self.contentView.backgroundColor!
        }
        set {
            self.contentView.backgroundColor = newValue
        }
    }
    
    override func awakeFromNib() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 4
    }
    
    override func prepareForReuse() {
        
    }
}
