//
//  TaskStepsController.swift
//  Steps
//
//  Created by Max Nelson on 8/29/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit


class TaskStepsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StepProtocol {
    
    
    var taskIndex:Int!
    var task:TaskModel!
    
    let model = Model.modelInstance
    
    let stepsCollection:UICollectionView = {
        let layout = TaskLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.borderColor = UIColor.darkGray.cgColor
        cv.register(StepCell.self, forCellWithReuseIdentifier: "StepCell")
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.MNOriginalDarkGray
        stepsCollection.backgroundColor = UIColor.MNOriginalDarkGray
        view.addSubview(stepsCollection)
        NSLayoutConstraint.activate(stepsCollection.getConstraintsTo(view: view, withInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))
        stepsCollection.delegate = self
        stepsCollection.dataSource = self
        
        task = model.tasks[taskIndex]
        print("number of steps \(self.task.steps.count)")
    }
    
    
    //cv data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return task.steps.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StepCell", for: indexPath) as! StepCell
        cell.step = task.steps[indexPath.item]
        cell.delegate = self
        cell.tag = indexPath.item
        cell.awakeFromNib()
        return cell
    }
    
    //cv delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    
    //step protocol
    //update status of cell
    func SetStepStatus(at: Int, status: Bool) {
        task.steps[at].isComplete = status
    }
    
    var test:Bool = false
    func InsertStep() {
        test = !test
        task.steps.append(StepModel(title: "new step: \(task.steps.count)", isComplete: test))
        let indexPath = IndexPath(item: task.steps.count - 1, section: 0)
        stepsCollection.performBatchUpdates({
            self.stepsCollection.insertItems(at: [indexPath])
        }, completion: { finished in
            self.stepsCollection.reloadData()
            self.stepsCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        })
    }
    
    
    func deleteStep(at:Int) {

        let indexPath = IndexPath(item: at, section: 0)
        task.steps.remove(at: at)
        stepsCollection.performBatchUpdates({
            self.stepsCollection.deleteItems(at: [indexPath])
        }, completion: { finished in
            self.stepsCollection.reloadData()
            self.stepsCollection.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        })
    }
    
}
