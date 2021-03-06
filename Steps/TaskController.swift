//
//  ViewController.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit
import WebKit

class TaskController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, TaskProtocol {
    
    let model = Model.modelInstance

    var t:TasksControllerHeaderView!
    let taskHeader:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let tasksCollection:UICollectionView = {
        let layout = TaskLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.borderColor = UIColor.darkGray.cgColor
        cv.register(TaskCell.self, forCellWithReuseIdentifier: "TaskCell")
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
//        cv.register(TaskCollectionHeaderView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "TasksHeader")
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
        let s = UIStackView(arrangedSubviews: [self.taskHeader, self.tasksCollection])
        s.axis = .vertical
        s.backgroundColor = .clear
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    var space:UIView = UIView()

    override func viewDidLoad() {

        super.viewDidLoad()
        


        t = TasksControllerHeaderView()
        t.barDelegate = self
        taskHeader.addSubview(t)
        NSLayoutConstraint.activate(t.getConstraintsTo(view: taskHeader, withInsets: UIEdgeInsetsMake(0, 10, 0, 10)))
        
        mainCollection.backgroundColor = UIColor.init(rgb: 0x232323)
        view.backgroundColor = UIColor.init(rgb: 0x232323)
        view.addSubview(mainCollection)
        NSLayoutConstraint.activate(mainCollection.getConstraintsTo(view: view, withInsets: UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)))

        mainCollection.delegate = self
        mainCollection.dataSource = self
        
    
//        self.taskHeader.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.InsertTask)))
    }

    
    //cv data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollection {
            return 2
        }
        return model.tasks.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == tasksCollection {
            return 1
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            if indexPath.item == 0 {
                if !cell.exists {
                    cell.awakeFromNib()
                    cell.contentView.addSubview(taskHeader)
                    NSLayoutConstraint.activate(taskHeader.getConstraintsTo(view: cell.contentView, withInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
                }
                return cell
            }
            if !cell.exists {
                cell.awakeFromNib()
                cell.contentView.addSubview(tasksCollection)
                NSLayoutConstraint.activate(tasksCollection.getConstraintsTo(view: cell.contentView, withInsets: UIEdgeInsetsMake(10, 0, 10, 0)))
                tasksCollection.delegate = self
                tasksCollection.dataSource = self
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.task = model.tasks[indexPath.row]
        cell.awakeFromNib()
        cell.taskHeaderView.actualMarkedButton.tag = indexPath.row
        cell.taskHeaderView.actualMarkedButton.addTarget(self, action: #selector(self.DeleteTask(sender:)), for: .touchUpInside)

        
        cell.isShakey = self.isRemovingCells
        
        
        if self.isRemovingCells {
            cell.recurseAnimation()
            UIView.animate(withDuration: 0.3, animations: {
                cell.taskHeaderView.markedButton.alpha = 1
                cell.taskHeaderView.progressGroup.alpha = 0.5
                cell.stepsLabel.alpha = 0.5
            })
            
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                cell.taskHeaderView.markedButton.alpha = 0
                cell.taskHeaderView.progressGroup.alpha = 1
                cell.stepsLabel.alpha = 1
            })
            
        }
        return cell
    }
    

    
    //cv delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollection {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.frame.width, height: collectionView.frame.height * 0.21)
            }
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height * 0.79) // + (CGFloat(model.tasks.count * 125))
        }
        return CGSize(width: 190, height: 135)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tasksCollection && self.isRemovingCells == false {
            (UIApplication.shared.delegate as! AppDelegate).NavigateToTaskSteps(taskIndex: indexPath.item)
        }
    }
    
    var isRemovingCells:Bool = false
    
    func RemoveTask() {
        print("hmm")
        isRemovingCells = !isRemovingCells
        self.tasksCollection.reloadData()
        //reload data to show or remove shakey animation
    }
    //insertion and deletion
    func DeleteTask(sender:UIButton) {
        if self.isRemovingCells == true {
            let atTag = sender.tag
            let indexPath = IndexPath(item: atTag, section: 0)
            model.tasks.remove(at: atTag)
            tasksCollection.performBatchUpdates({
                self.tasksCollection.deleteItems(at: [indexPath])
            }, completion: { finished in
                self.tasksCollection.reloadData()
            })
        }

    }
    
    func NewTaskController() {
        (UIApplication.shared.delegate as! AppDelegate).NavigateToNewTaskController()
    }
    
    func InsertTask(withTitle:String, withColor:UIColor) {
        model.tasks.append(TaskModel(isMarked: false, percentComplete: 0, stepsComplete: "0", title: withTitle, isComplete: false, steps: [], color: withColor))

        let indexPath = IndexPath(item: model.tasks.count - 1, section: 0)
        tasksCollection.performBatchUpdates({
            self.tasksCollection.insertItems(at: [indexPath])
        }, completion: { finished in
            self.tasksCollection.reloadData()
            self.tasksCollection.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        })
    }
    
    func updateCollection() {
        tasksCollection.reloadData()
  
        var totalStepsComplete:Double = 0
        var totalSteps:Double = 0
        for task in model.tasks {
            totalStepsComplete += Double(task.steps.filter({$0.isComplete == true}).count)
            totalSteps += Double(task.steps.count)
        }
        if totalSteps == 0 {
            t.totalPercent = 0
        } else {
            t.totalPercent = (totalStepsComplete / totalSteps) * 100.0
        }
        
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if collectionView == tasksCollection {
//            switch kind {
//            case UICollectionElementKindSectionHeader:
//                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TasksHeader", for: indexPath) as! TaskCollectionHeaderView
//                header.awakeFromNib()
//                return header
//            default:
//                break
//            }
//        }
//        return UICollectionReusableView()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if collectionView == tasksCollection {
//            return CGSize(width: collectionView.frame.width - 20, height: 55)
//        }
//        return .zero
//    }
//    
    
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
//            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
//        }, completion: nil)
//    }

}

