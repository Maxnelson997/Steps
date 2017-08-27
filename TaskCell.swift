//
//  TaskCell.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class EmptyCell:UICollectionViewCell {
    override func awakeFromNib() {
        
    }
    override func prepareForReuse() {
        
    }
}

class TaskCell: UICollectionViewCell {
    
    var taskHeaderView:TaskHeaderView = TaskHeaderView()
    
    fileprivate var stepsLabel:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaLight, withSize: 15)
        l.text = "steps label"
        
        return l
    }()
    
    fileprivate var taskTitle:UILabel = {
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
    //pass in Task struct and set data this way.
    override func awakeFromNib() {
        contentView.backgroundColor = UIColor.MNGray
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 6
        taskHeaderView.isMarked = task.isMarked
        taskHeaderView.completionPercent = task.percentComplete

        addSubview(viewStack)
      
        NSLayoutConstraint.activate(viewStack.getConstraintsTo(view: contentView, withInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)))
        
        NSLayoutConstraint.activate(
            viewStack.addViewsWithCons(direction: [.vertical],views: [
                ViewMultiplier(view: taskHeaderView, multiplier: 0.6),
                ViewMultiplier(view: stepsLabel, multiplier: 0.2),
                ViewMultiplier(view: taskTitle, multiplier: 0.2),
                ])
        )
    
        stepsLabel.text = "\(String(describing: task.steps.count)) steps"
        taskTitle.text = task.title
    }

    override func prepareForReuse() {
        
    }
    
    
}
