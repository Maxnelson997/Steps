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
    
    var textDelegate:UITextFieldDelegate {
        get {
            return stepTitle.delegate!
        }
        set {
            stepTitle.delegate = newValue
        }
    }
    
    var step:StepModel!
    
    fileprivate var bubbleContainer:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate var titleContainer:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate var completeBubble:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaLight, withSize: 35)
        l.text = "0"
        l.setFAIcon(icon: .FACircleO, iconSize: 25)
        l.setFAColor(color: UIColor.MNGreen)
        return l
    }()
    
//    fileprivate var stepTitle:UILabel = {
//        let l = MNLabel(customFont: .ProximaNovaLight, withSize: 25)
//        l.text = "steps to complete"
//        l.textAlignment = .left
//        return l
//    }()
    

    fileprivate var stepTitle:UITextField = {
        let t = UITextField()
        t.font = UIFont.init(customFont: .ProximaNovaLight, withSize: 25)
        t.placeholder = "Step"
        t.translatesAutoresizingMaskIntoConstraints = false
        t.textColor = UIColor.MNTextGray
//        t.textAlignment = .left
        return t
    }()
    
    fileprivate var viewStack:UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    override func awakeFromNib() {
        stepTitle.text = step.title
        tapped = step.isComplete
        stepTitle.tag = self.tag
        if tapped == true {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 5
            completeBubble.setFAIcon(icon: .FACheckCircle, iconSize: 25)
            let attTitle = NSMutableAttributedString(string: stepTitle.text!)
            //strikethrough
            attTitle.setAttributes([NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue),NSStrikethroughColorAttributeName:UIColor.MNTextGray], range: NSRange(location: 0,length: attTitle.length))
            stepTitle.isUserInteractionEnabled = false
            stepTitle.alpha = 0.5
            stepTitle.attributedText = attTitle
        }
        
        if !exists {
            bubbleContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.completeTap)))
            viewStack.insertArrangedSubview(self.bubbleContainer, at: 0)
            viewStack.insertArrangedSubview(self.titleContainer, at: 1)
            
            bubbleContainer.addSubview(completeBubble)
            NSLayoutConstraint.activate([
                completeBubble.topAnchor.constraint(equalTo: bubbleContainer.topAnchor),
                completeBubble.bottomAnchor.constraint(equalTo: bubbleContainer.bottomAnchor),
                completeBubble.leftAnchor.constraint(equalTo: bubbleContainer.leftAnchor)
                ])
            
            titleContainer.addSubview(stepTitle)
            NSLayoutConstraint.activate([
                stepTitle.leftAnchor.constraint(equalTo: titleContainer.leftAnchor),
                stepTitle.rightAnchor.constraint(equalTo: titleContainer.rightAnchor),
                stepTitle.topAnchor.constraint(equalTo: titleContainer.topAnchor),
                stepTitle.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor),
                stepTitle.heightAnchor.constraint(equalTo: titleContainer.heightAnchor),
                stepTitle.widthAnchor.constraint(equalTo: titleContainer.widthAnchor)
                ])
            
            contentView.addSubview(viewStack)
            NSLayoutConstraint.activate(viewStack.getConstraintsTo(view: contentView, withInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)))
            NSLayoutConstraint.activate([
                
                bubbleContainer.widthAnchor.constraint(equalTo: viewStack.widthAnchor, multiplier: 0.1),
                titleContainer.widthAnchor.constraint(equalTo: viewStack.widthAnchor, multiplier: 0.9),
                
                ])
            exists = true
        }
    }
    
    override func prepareForReuse() {
        
    }
    
    func completeTap() {
        tapped = !tapped
        let attTitle = NSMutableAttributedString(string: stepTitle.text!)
        if tapped {
            //strikethrough
            attTitle.setAttributes([NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue),NSStrikethroughColorAttributeName:UIColor.MNTextGray], range: NSRange(location: 0,length: attTitle.length))
            stepTitle.isUserInteractionEnabled = false
            stepTitle.alpha = 0.5
            stepTitle.attributedText = attTitle
            completeBubble.setFAIcon(icon: .FACheckCircle, iconSize: 25)
        } else {
            //no strikethrough
            attTitle.setAttributes([NSStrikethroughStyleAttributeName: NSNumber(value: NSUnderlineStyle.styleNone.rawValue),NSForegroundColorAttributeName:UIColor.MNTextGray], range: NSRange(location: 0,length: attTitle.length))
            stepTitle.isUserInteractionEnabled = true
            stepTitle.alpha = 1
            stepTitle.attributedText = attTitle
            completeBubble.setFAIcon(icon: .FACircleO, iconSize: 25)
        }
        
        print("tapped: \(self.tapped)")
        delegate.SetStepStatus(at: self.tag, status: tapped)
    }
}
