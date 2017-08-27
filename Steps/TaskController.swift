//
//  ViewController.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class TaskController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    let model = Model.modelInstance
    
    let taskHeader:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        let t = TasksControllerHeaderView()
        v.addSubview(t)
        NSLayoutConstraint.activate(t.getConstraintsTo(view: v, withInsets: UIEdgeInsetsMake(0, 10, 0, 10)))
        return v
    }()

    let tasksCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.sectionFootersPinToVisibleBounds = true
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.borderColor = UIColor.darkGray.cgColor
        cv.register(TaskCell.self, forCellWithReuseIdentifier: "TaskCell")
        cv.backgroundColor = .clear
        return cv
    }()
    
    let mainCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.sectionFootersPinToVisibleBounds = true
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.borderColor = UIColor.darkGray.cgColor
        cv.register(EmptyCell.self, forCellWithReuseIdentifier: "EmptyCell")
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
        mainCollection.backgroundColor = UIColor.init(rgb: 0x232323)
        view.backgroundColor = UIColor.init(rgb: 0x232323)
        view.addSubview(mainCollection)
        NSLayoutConstraint.activate(mainCollection.getConstraintsTo(view: view, withInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
        mainCollection.delegate = self
        mainCollection.dataSource = self
    }

    
    //cv data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollection {
            return 2
        }
        return model.tasks.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            if indexPath.item == 0 {
                cell.contentView.addSubview(taskHeader)
                NSLayoutConstraint.activate(taskHeader.getConstraintsTo(view: cell.contentView, withInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
                return cell
            }
            cell.contentView.addSubview(tasksCollection)
            NSLayoutConstraint.activate(tasksCollection.getConstraintsTo(view: cell.contentView, withInsets: UIEdgeInsetsMake(10, 0, 0, 0)))
            tasksCollection.delegate = self
            tasksCollection.dataSource = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.task = model.tasks[indexPath.row]
        cell.awakeFromNib()
        return cell
    }
    
    //cv delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollection {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.frame.width, height: collectionView.frame.height * 0.25)
            }
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height * 0.5) // + (CGFloat(model.tasks.count * 125))
        }
        return CGSize(width: 200, height: 125)
    }

    
    
    
    
    

}
