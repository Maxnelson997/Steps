//
//  TaskCell.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class EmptyCell:UICollectionViewCell {
    var exists:Bool = false
    override func awakeFromNib() {
        exists = true
    }
    override func prepareForReuse() {
        
    }
}

class TaskCell: UICollectionViewCell {
    
    var isShakey:Bool = false
    func recurseAnimation() {
        
        UIView.animate(withDuration: 0.5, animations: {
//            self.transform = CGAffineTransform(rotationAngle: 350)
            self.taskHeaderView.progressGroup.transform = CGAffineTransform(translationX: -10, y: 0)
            self.taskHeaderView.percentage.transform = CGAffineTransform(translationX: -10, y: 0)
            self.stepsLabel.transform  = CGAffineTransform(translationX: -10, y: 0)
            self.taskTitle.transform  = CGAffineTransform(translationX: -10, y: 0)
        }, completion: { finished in
            UIView.animate(withDuration: 0.5, animations: {
//                self.transform = CGAffineTransform(rotationAngle: 370)
                self.taskHeaderView.percentage.transform  = CGAffineTransform(translationX: 10, y: 0)
                self.taskHeaderView.progressGroup.transform  = CGAffineTransform(translationX: 10, y: 0)
                self.stepsLabel.transform  = CGAffineTransform(translationX: 10, y: 0)
                self.taskTitle.transform  = CGAffineTransform(translationX: 10, y: 0)
                
            }, completion: { finished in
                if self.isShakey {
                    self.recurseAnimation()
                } else {
//                    self.transform = CGAffineTransform(rotationAngle: -180)
                    self.taskHeaderView.progressGroup.transform  = CGAffineTransform(translationX: 0, y: 0)
                    self.taskHeaderView.percentage.transform  = CGAffineTransform(translationX: 0, y: 0)
                    self.stepsLabel.transform  = CGAffineTransform(translationX: 0, y: 0)
                    self.taskTitle.transform  = CGAffineTransform(translationX: 0, y: 0)
                }
            })
        })
    }
    
    var taskHeaderView:TaskHeaderView = TaskHeaderView()
    var exists:Bool = false
    var stepsLabel:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaLight, withSize: 15)
        l.text = "steps label"
        
        return l
    }()
    
    var taskTitle:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaLight, withSize: 15)
        l.text = "task title"

        return l
    }()
    
    fileprivate lazy var viewStack:UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    var task:TaskModel!
    var numberComplete:Int!
    //pass in Task struct and set data this way.
    override func awakeFromNib() {
        taskHeaderView.isMarked = task.isMarked
        if task.steps.count != 0 {
            task.percentComplete = Double(task.steps.filter({$0.isComplete == true}).count) / Double(task.steps.count)
        } else {
            task.percentComplete = 0
        }

        taskHeaderView.completionPercent = task.percentComplete
        if !exists {
            exists = true
            contentView.backgroundColor = UIColor.MNGray
            contentView.layer.masksToBounds = true
            contentView.layer.cornerRadius = 4
            
            addSubview(viewStack)
            
            NSLayoutConstraint.activate(viewStack.getConstraintsTo(view: contentView, withInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)))
            
            NSLayoutConstraint.activate(
                viewStack.addViewsWithCons(direction: [.vertical],views: [
                    ViewMultiplier(view: taskHeaderView, multiplier: 0.6),
                    ViewMultiplier(view: stepsLabel, multiplier: 0.2),
                    ViewMultiplier(view: taskTitle, multiplier: 0.2),
                    ])
            )
            
        }
        
        stepsLabel.text = "\(String(describing: task.steps.count)) steps - \(String(describing: task.steps.filter({ $0.isComplete! == true }).count)) complete"
        taskTitle.text = task.title
    }

    override func prepareForReuse() {
        
    }
    
    
}
