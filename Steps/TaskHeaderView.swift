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
        progressGroup.ringWidth = 6
        return progressGroup
    }()
    
    var percentage:MNLabel = {
        let l = MNLabel(customFont: .ProximaNovaRegular, withSize: 20)
        l.text = "80"
        l.textAlignment = .center
        return l
    }()
    
    var actualMarkedButton:UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        b.layer.borderColor = UIColor.MNBlue.cgColor
        b.layer.borderWidth = 2
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 2
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    var markedButton:UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
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
        progressGroup.addSubview(percentage)
        
        markedButton.addSubview(actualMarkedButton)
        actualMarkedButton.addTarget(self, action: #selector(self.animateMarking), for: .touchUpInside)
        NSLayoutConstraint.activate([actualMarkedButton.rightAnchor.constraint(equalTo: markedButton.rightAnchor, constant: -5), actualMarkedButton.topAnchor.constraint(equalTo: markedButton.topAnchor, constant: 5), actualMarkedButton.widthAnchor.constraint(equalToConstant: 30), actualMarkedButton.heightAnchor.constraint(equalToConstant: 15)])
       

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
        
//        NSLayoutConstraint.activate(progressGroup.getConstraintsOfView(to: percentView))
//        NSLayoutConstraint.activate(percentage.getConstraintsOfView(to: percentView))
    
        NSLayoutConstraint.activate(progressGroup.getConstraintsTo(view: percentView, withInsets: UIEdgeInsetsMake(5, 0, 5, 5)))
        NSLayoutConstraint.activate(percentage.getConstraintsTo(view: progressGroup, withInsets: UIEdgeInsetsMake(0, 0, 0, 0)))
        
        updateMainGroupProgress()
    }
    
    var yeppers:Double = 0
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
        print(completionPercent)

        
        if completionPercent == 0.0 {
            progressGroup.ring1.progress = 0
        } else {
            progressGroup.ring1.progress = self.completionPercent
        }
       
        
        print("completion percent: \(self.completionPercent)")
        print("progressgroup ring 1 progress: \(progressGroup.ring1.progress)")
        newText = "\(String(describing: Int(progressGroup.ring1.progress*100)))%"
        print("newtext: \(String(describing: Int(progressGroup.ring1.progress*100)))%")
        //        percentage.animate(toText: newText)
        
        CATransaction.commit()
        
        
        recurse()
    }
    var duration:Double = 0.005
    func recurse() {
        UIView.animate(withDuration: duration, animations: {
            self.percentage.text = "\(self.currentPer)%"

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
            yep = !newValue
            animateMarking()
        }
    }
    
    func animateMarking() {
        yep = !yep
        if yep {
            actualMarkedButton.backgroundColor = UIColor.MNBlue
        } else {
            actualMarkedButton.backgroundColor = UIColor.clear
        }
    }
    
    

}
