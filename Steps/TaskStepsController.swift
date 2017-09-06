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
        textField.moveTextField(inView: self.view, moveDistance: 150, up: true)
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
        textField.moveTextField(inView: self.view, moveDistance: 150, up: false)
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
    
    fileprivate var viewStack:UIStackView = {
       let viewStack = UIStackView()
        viewStack.translatesAutoresizingMaskIntoConstraints = false
        viewStack.axis = .vertical
        return viewStack
    }()
    
    
    var headerView:StepsControllerHeaderViewReusableView = StepsControllerHeaderViewReusableView()
    
    let stepsCollection:UICollectionView = {
        let layout = StepLayout()

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.borderColor = UIColor.darkGray.cgColor
        cv.register(StepCell.self, forCellWithReuseIdentifier: "StepCell")
        cv.backgroundColor = UIColor.MNGray
        cv.layer.cornerRadius = 10
        cv.layer.masksToBounds = true
//        cv.register(StepsControllerHeaderViewReusableView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "StepsHeader")
        return cv
    }()
    
    override func viewDidLoad() {
        updateHeaderView()
        view.backgroundColor = UIColor.MNOriginalDarkGray
//        stepsCollection.backgroundColor = UIColor.MNOriginalDarkGray
        view.addSubview(viewStack)
        viewStack.addArrangedSubview(headerView)
        viewStack.addArrangedSubview(stepsCollection)
        NSLayoutConstraint.activate(viewStack.getConstraintsTo(view: view, withInsets: UIEdgeInsets(top: 60, left: 15, bottom: 60, right: 15)))
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalTo: viewStack.heightAnchor, multiplier: 0.35),
            stepsCollection.heightAnchor.constraint(equalTo: viewStack.heightAnchor, multiplier: 0.65)
            ])
        stepsCollection.delegate = self
        stepsCollection.dataSource = self
        stepsCollection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissTextField)))
        print("number of steps \(model.tasks[taskIndex].steps.count)")
    }
    
    func updateHeaderView() {
        model.tasks[taskIndex].stepsComplete = String(model.tasks[taskIndex].steps.filter({$0.isComplete == true}).count)
        model.tasks[taskIndex].percentComplete = Double(model.tasks[taskIndex].steps.filter({$0.isComplete == true}).count) / Double(model.tasks[taskIndex].steps.count)
        //
        headerView.title = model.tasks[taskIndex].title
        headerView.steps = "\(model.tasks[taskIndex].steps.count) steps - \(model.tasks[taskIndex].stepsComplete!) complete"
        headerView.percentage = model.tasks[taskIndex].percentComplete
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.model.tasks[self.taskIndex].percentComplete == 1 {
                self.headerView.percentageColor = UIColor.MNGreen
            } else {
                self.headerView.percentageColor = UIColor.white
            }
        })

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
        cell.backgroundColor = UIColor.MNGray
        cell.awakeFromNib()
        return cell
    }
    
    //cv delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionElementKindSectionHeader:
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "StepsHeader", for: indexPath) as! StepsControllerHeaderViewReusableView
//            header.awakeFromNib()
//            //
//            model.tasks[taskIndex].stepsComplete = String(model.tasks[taskIndex].steps.filter({$0.isComplete == true}).count)
//            model.tasks[taskIndex].percentComplete = Double(model.tasks[taskIndex].steps.filter({$0.isComplete == true}).count) / Double(model.tasks[taskIndex].steps.count)
//            //
//            header.title = model.tasks[taskIndex].title
//            header.steps = "\(model.tasks[taskIndex].steps.count) steps - \(model.tasks[taskIndex].stepsComplete!) complete"
//            header.percentage = model.tasks[taskIndex].percentComplete
//            
//            return header
//        default:
//            break
//        }
//        return UICollectionReusableView()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height * 0.3)
//    }
//    
//    
    //step protocol
    //update status of cell
    func SetStepStatus(at: Int, status: Bool) {
        print("old status \(model.tasks[taskIndex].steps[at].isComplete)")
        model.tasks[taskIndex].steps[at].isComplete = status
        print("new status \(model.tasks[taskIndex].steps[at].isComplete)")
        updateHeaderView()
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
        self.updateHeaderView()
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
