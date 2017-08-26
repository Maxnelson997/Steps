//
//  ViewController.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class TaskController: UIViewController {
    
    let taskHeader = TaskHeaderView()
    
    let tasksCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.sectionFootersPinToVisibleBounds = true
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.borderColor = UIColor.darkGray.cgColor
        cv.backgroundColor = .clear
        return cv
    }()

    
    fileprivate lazy var viewStack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.taskHeader, self.space, self.tasksCollection])
        s.axis = .vertical
        s.backgroundColor = .clear
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    var space:UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(rgb: 0x232323)
        view.addSubview(viewStack)
        
//        NSLayoutConstraint.activate(viewStack.getConstraintsOfView(to: view))
        NSLayoutConstraint.activate(viewStack.getConstraintsTo(view: view, withInsets: UIEdgeInsets(top: 70, left: 10, bottom: 55, right: 10)))
        NSLayoutConstraint.activate([
            taskHeader.heightAnchor.constraint(equalTo: viewStack.heightAnchor, multiplier: 0.3),
            space.heightAnchor.constraint(equalTo: viewStack.heightAnchor, multiplier: 0.1),
            tasksCollection.heightAnchor.constraint(equalTo: viewStack.heightAnchor, multiplier: 0.6)
            ])
        
        
    }



}

