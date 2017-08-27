//
//  MNLabel.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit



class MNLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo()
    }
    
    init() {
        super.init(frame: .zero)
        phaseTwo()
    }
    
    init(withFont: UIFont) {
        super.init(frame: .zero)
        self.font = withFont
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(customFont: CustomFont, withSize: CGFloat) {
        super.init(frame: .zero)
        self.adjustsFontSizeToFitWidth = true
        self.font = UIFont.init(customFont: customFont, withSize: withSize)
        self.textColor = UIColor.MNTextGray
        self.translatesAutoresizingMaskIntoConstraints = false
        self.adjustsFontForContentSizeCategory = true
        self.textAlignment = .left
        phaseTwo()
    }
    
    func phaseTwo() {
        //        self.adjustsFontForContentSizeCategory = true

    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)))
    }

}
