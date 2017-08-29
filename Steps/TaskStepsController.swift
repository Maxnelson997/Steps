//
//  TaskStepsController.swift
//  Steps
//
//  Created by Max Nelson on 8/29/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit


class TaskStepsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, StepProtocol, UITextFieldDelegate {
    
    var currentTextField:UITextField = UITextField()
    
    func dismissTextField() {
        currentTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        
        currentTextField = textField
        textField.layer.cornerRadius = 5
        let animateSize = textField.frame.width / 9

        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveEaseIn, animations: {
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: 1.1, y: 1.1)
            transform = transform.translatedBy(x: animateSize, y: 0)
            textField.transform = transform
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.cornerRadius = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveEaseIn, animations: {
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: 1, y: 1)
            transform = transform.translatedBy(x: 0, y: 0)
            textField.transform = transform
        })
        model.tasks[taskIndex].steps[textField.tag].title = textField.text
    }
    var taskIndex:Int!
    
    let model = Model.modelInstance
    
    let stepsCollection:UICollectionView = {
        let layout = TaskLayout()
        layout.scrollDirection = .vertical
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
        stepsCollection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissTextField)))
        
        print("number of steps \(model.tasks[taskIndex].steps.count)")
    }
    
    
    //cv data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.tasks[taskIndex].steps.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StepCell", for: indexPath) as! StepCell
        cell.step = model.tasks[taskIndex].steps[indexPath.item]
        cell.delegate = self
        cell.textDelegate = self
        cell.tag = indexPath.item
        cell.awakeFromNib()
        return cell
    }
    
    //cv delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 30, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    //step protocol
    //update status of cell
    func SetStepStatus(at: Int, status: Bool) {
        print("old status \(model.tasks[taskIndex].steps[at].isComplete)")
        model.tasks[taskIndex].steps[at].isComplete = status
        print("new status \(model.tasks[taskIndex].steps[at].isComplete)")
    }
    
    

    func InsertStep() {
        model.tasks[taskIndex].steps.append(StepModel(title: "new step: \(model.tasks[taskIndex].steps.count)", isComplete: false))
        let indexPath = IndexPath(item: model.tasks[taskIndex].steps.count - 1, section: 0)
        stepsCollection.performBatchUpdates({
            self.stepsCollection.insertItems(at: [indexPath])
        }, completion: { finished in
//            self.stepsCollection.reloadData()
            self.stepsCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        })
    }
    
    
    func deleteStep(at:Int) {

        let indexPath = IndexPath(item: at, section: 0)
        model.tasks[taskIndex].steps.remove(at: at)
        stepsCollection.performBatchUpdates({
            self.stepsCollection.deleteItems(at: [indexPath])
        }, completion: { finished in
            self.stepsCollection.reloadData()
            self.stepsCollection.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        })
    }
    
}
