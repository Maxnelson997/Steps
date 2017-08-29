//
//  StepCell.swift
//  Steps
//
//  Created by Max Nelson on 8/29/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class StepCell:UICollectionViewCell {
    
    var exists:Bool = false
    var tapped:Bool = false
    
    var delegate:StepProtocol!
    
    var step:StepModel!
    
    fileprivate var bubbleContainer:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate var completeBubble:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaLight, withSize: 15)
        l.text = "0"
        l.setFAIcon(icon: .FACircleO, iconSize: 15)
        l.setFAColor(color: UIColor.MNGreen)
        return l
    }()
    
    fileprivate var stepTitle:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaLight, withSize: 15)
        l.text = "steps to complete"
        
        return l
    }()
    
    fileprivate var viewStack:UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    

    override func awakeFromNib() {
        stepTitle.text = step.title
        tapped = step.isComplete
        completeTap()
        if !exists {

            viewStack.insertArrangedSubview(self.bubbleContainer, at: 0)
            viewStack.insertArrangedSubview(self.stepTitle, at: 1)
            
            bubbleContainer.addSubview(completeBubble)
            NSLayoutConstraint.activate([
                completeBubble.widthAnchor.constraint(equalTo: bubbleContainer.heightAnchor, multiplier: 1),
                completeBubble.heightAnchor.constraint(equalTo: bubbleContainer.heightAnchor, multiplier: 1),
                completeBubble.leftAnchor.constraint(equalTo: bubbleContainer.leftAnchor)
                ])
            
            contentView.addSubview(viewStack)
            NSLayoutConstraint.activate(viewStack.getConstraintsTo(view: contentView, withInsets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)))
            NSLayoutConstraint.activate([
                
                bubbleContainer.widthAnchor.constraint(equalTo: viewStack.widthAnchor, multiplier: 0.3),
                stepTitle.widthAnchor.constraint(equalTo: viewStack.widthAnchor, multiplier: 0.7),
                
                ])
            exists = true
        }
    }
    
    override func prepareForReuse() {
        
    }
    
    func completeTap() {
        tapped = !tapped
        if tapped {
            completeBubble.setFAIcon(icon: .FACheckCircle, iconSize: 15)
        } else {
            completeBubble.setFAIcon(icon: .FACircle, iconSize: 15)
        }
        delegate.SetStepStatus(at: self.tag, status: tapped)
    }
}
