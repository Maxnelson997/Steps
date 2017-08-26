//
//  TaskHeaderView.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class TaskHeaderView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo()
    }
    
    init() {
        super.init(frame: .zero)
        phaseTwo()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func phaseTwo() {
        self.axis = .vertical
        self.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            self.addViewsWithCons(direction: [.vertical],views: [
                ViewMultiplier(view: helloLabel, multiplier: 0.35),
                ViewMultiplier(view: dateLabel, multiplier: 0.35),
                ViewMultiplier(view: progressLabel, multiplier: 0.25),
//                ViewMultiplier(view: UIView(), multiplier: 0.1),
                ViewMultiplier(view: progressBar, multiplier: 0.05)
                ])
        )
        

    }
    
    //member views - member variables
    fileprivate var helloLabel:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaLight, withSize: 45)
        l.text = "Hello Max!"
        return l
    }()
    
    fileprivate var dateLabel:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaLight, withSize: 45)
        l.text = "Friday 25"
        
        return l
    }()
    
    fileprivate var progressLabel:MNLabel = {
        let l = MNLabel(customFont: .ProximaNovaLight, withSize: 25)
        var title = NSMutableAttributedString()
            title = NSMutableAttributedString(string: "Total progress across all tasks - 74%", attributes: [NSForegroundColorAttributeName:UIColor.MNTextGray])
        print("char count: \(title.string.characters.count)")
        title.setAttributes([NSFontAttributeName: UIFont.init(customFont: .ProximaNovaSemibold, withSize: 40)!], range: NSRange(location: title.string.characters.count - 3, length: 3))
        l.attributedText = title
        return l
    }()
    
    fileprivate var progressBar:UIView = {
        let l = MNLabel(customFont: .ProximaNovaLight, withSize: 18)
        l.layer.cornerRadius = 4
        l.layer.masksToBounds = true
        l.backgroundColor = UIColor.MNGreen
        l.translatesAutoresizingMaskIntoConstraints = false
//        l.drawText(in: UIEdgeInsetsInsetRect(l.frame, UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)))
        return l
    }()

}
