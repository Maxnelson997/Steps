//
//  TaskHeaderView.swift
//  Steps
//
//  Created by Max Nelson on 8/26/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit


class TaskHeaderView: UIStackView {
    
    var percentView:UIView = UIView()
    
    var progressGroup: MKRingProgressGroupView = {
        let progressGroup = MKRingProgressGroupView()
        progressGroup.translatesAutoresizingMaskIntoConstraints = false
        progressGroup.ring1.progress = 0
        progressGroup.ringWidth = 8
        return progressGroup
    }()
    
    var percentage:MNLabel = {
        let l = MNLabel()
        l.text = ""
        l.textColor = UIColor.MNTextGray
        l.backgroundColor = .clear
        l.textAlignment = .center
        l.font = UIFont.init(customFont: .ProximaNovaRegular, withSize: 40)
        return l
    }()
    
    var markedButton:UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.isUserInteractionEnabled = false
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        b.backgroundColor = UIColor.MNBlue
        b.layer.borderColor = UIColor.MNBlue.cgColor
        b.layer.borderWidth = 4
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 4
        b.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(b)
        NSLayoutConstraint.activate([b.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -5), b.topAnchor.constraint(equalTo: container.topAnchor, constant: 5), b.widthAnchor.constraint(equalToConstant: 30), b.heightAnchor.constraint(equalToConstant: 15)])
        return container
    }()
    
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
        percentView.addSubview(progressGroup)
        percentView.addSubview(percentage)
//          percentView.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        self.axis = .vertical
        self.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            self.addViewsWithCons(direction: [.horizontal],views: [
                ViewMultiplier(view: percentView, multiplier: 0.5),
                ViewMultiplier(view: markedButton, multiplier: 0.5),
                ])
        )
        
        NSLayoutConstraint.activate(progressGroup.getConstraintsOfView(to: percentView))
        NSLayoutConstraint.activate(percentage.getConstraintsOfView(to: percentView))
        updateMainGroupProgress()
//        NSLayoutConstraint.activate(progressGroup.getConstraintsTo(view: percentView, withInsets: .zero))
//        NSLayoutConstraint.activate(percentage.getConstraintsTo(view: percentView, withInsets: .zero))
    }
    
    var yeppers:Double = 0.0
    var completionPercent:Double {
        get {
            return yeppers
        } set {
            yeppers = newValue

            self.progressGroup.ring1.progress = self.completionPercent
            
            updateMainGroupProgress()
        }
    }
    
    //member methods
    var newText:String = ""
    var currentText:String = ""
    var currentPer:Int = 0
    
    var lastPer:Int = 0
    func updateMainGroupProgress() {
        
        self.newText = ""
        
        self.currentText = ""
        CATransaction.begin()

        progressGroup.ring1.progress = self.completionPercent/100
        newText = "\(String(describing: Int(progressGroup.ring1.progress*100)))%"
        //        percentage.animate(toText: newText)
        
        
        CATransaction.commit()
        
        
        recurse()
    }
    var duration:Double = 0.005
    func recurse() {
        UIView.animate(withDuration: duration, animations: {
            self.percentage.text = "\(self.currentPer)%"
            //            self.percentage.text = self.newText
        }, completion: { finished in
            delay(self.duration, closure: {
                if self.percentage.text != self.newText {
                    if self.lastPer > Int(self.progressGroup.ring1.progress*100) {
                        self.currentPer -= 1
                    } else {
                        self.currentPer += 1
                    }
                    self.duration += 0.0001
                    self.recurse()
                } else {
                    self.lastPer = self.currentPer
                }
            })
            
        })
    }

    var yep:Bool = false
    var isMarked:Bool {
        get {
            return yep
        } set {
            yep = newValue
            animateMarking()
        }
    }
    
    func animateMarking() {
        if yep {
            markedButton.backgroundColor = UIColor.MNBlue
        } else {
            markedButton.backgroundColor = UIColor.clear
        }
    }


}
