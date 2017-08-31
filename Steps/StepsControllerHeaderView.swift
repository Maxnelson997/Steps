//
//  StepsControllerHeaderView.swift
//  Steps
//
//  Created by Max Nelson on 8/30/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class StepsControllerHeaderViewReusableView:UIView {

    let viewStack = StepsControllerHeaderView()
    
    var title:String {
        get {
            return viewStack.titleLabel.text!
        }
        set {
            viewStack.titleLabel.text = newValue
        }
    }
    
    var steps:String {
        get {
            return viewStack.stepsLabel.text!
        }
        set {
            viewStack.stepsLabel.text = newValue
        }
    }
    
    var percentage:Double {
        get {
            return Double(viewStack.percentageLabel.text!)!
        }
        set {
            if newValue.isNaN {
                viewStack.percentageLabel.text = "0%"
                return
            }
            viewStack.percentageLabel.text = String(describing: Int(newValue * 100)) + "%"
        }
    }
    
    var percentageColor:UIColor {
        get {
            return viewStack.percentageLabel.textColor
        } set {
            viewStack.percentageLabel.textColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: .zero)
        phaseTwo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func phaseTwo() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.MNOriginalDarkGray.withAlphaComponent(0.95)
        addSubview(viewStack)
        NSLayoutConstraint.activate(viewStack.getConstraintsTo(view: self, withInsets: UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)))
    }
    
}

class StepsControllerHeaderView:UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo()
    }
    
    init() {
        super.init(frame: .zero)
        phaseTwo()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func phaseTwo() {
        self.axis = .vertical
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            self.addViewsWithCons(direction: [.vertical], views: [
                
                ViewMultiplier(view: titleLabel, multiplier: 1/3),
                ViewMultiplier(view: stepsLabel, multiplier: 1/3),
                ViewMultiplier(view: percentageLabel, multiplier: 1/3)
                
                ])
        )
    
    }
    
    fileprivate var titleLabel:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaRegular, withSize: 35)
        l.text = "title label placeholder"
        return l
    }()
    
    fileprivate var stepsLabel:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaRegular, withSize: 35)
        l.text = "11 steps - 6 complete"
        return l
    }()
    
    fileprivate var percentageLabel:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaRegular, withSize: 45)
        l.text = "76%" //placeholder
        return l
    }()

}
