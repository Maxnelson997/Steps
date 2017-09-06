//
//  NewTaskFormController.swift
//  Steps
//
//  Created by Max Nelson on 8/31/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class NewTaskFormController:UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: 1.2, y: 1.2)
            transform = transform.translatedBy(x: (textField.frame.width * 0.1), y: 0)
            textField.transform = transform
            self.colorLabel.alpha = 0.1
            self.colorCollection.alpha = 0.1
//            self.titleLabel.alpha = 0
            self.colorLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.colorCollection.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.doneButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.doneButton.alpha = 1
            self.navigationController?.navigationBar.isHidden = true
            self.navigationController?.navigationBar.alpha = 0
        }, completion: { finished in
//            self.titleLabel.text = "Editing Task Name"
//            UIView.animate(withDuration: 0.3, animations: {
//                self.titleLabel.alpha = 1
//            })
        })
     
        
        textField.moveTextField(inView: self.viewStack, moveDistance: 55, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
 
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: 1, y: 1)
            transform = transform.translatedBy(x: 0, y: 0)
            textField.transform = transform
            self.colorLabel.alpha = 1
            self.colorCollection.alpha = 1
//            self.titleLabel.alpha = 0
            self.colorLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.colorCollection.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.doneButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.doneButton.alpha = 0
           
        }, completion: { finished in
        
                self.navigationController?.navigationBar.isHidden = false
             self.navigationController?.navigationBar.alpha = 1
//            self.titleLabel.text = "Task Name"
//            UIView.animate(withDuration: 0.3, animations: {
//                self.titleLabel.alpha = 1
//            })
        })

        
        textField.moveTextField(inView: self.viewStack, moveDistance: 55, up: false)
    }
    
    
    var colors:[UIColor] = [UIColor.MNGreen, UIColor.MNBlue, UIColor.MNDarkGray, UIColor.MNTextGray, UIColor.MNMagenta]
    
    var selectedColorIndex:Int = 0
    
    var viewStack:UIStackView = {
       let s = UIStackView()
        s.axis = .vertical
        s.translatesAutoresizingMaskIntoConstraints = false
        s.spacing = 15
        return s
    }()
    
    fileprivate var titleLabel:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaRegular, withSize: 35)
        l.text = "Task Name"
        return l
    }()

    fileprivate var titleBox:UITextField = {
        let t = UITextField()
        t.font = UIFont.init(customFont: .ProximaNovaLight, withSize: 25)
//        t.placeholder = "Get good grades"
        t.translatesAutoresizingMaskIntoConstraints = false
        t.textColor = UIColor.MNTextGray
        t.attributedPlaceholder = NSAttributedString(string: "get good grades", attributes: [NSForegroundColorAttributeName:UIColor.MNTextGray.withAlphaComponent(0.5)])
//        t.backgroundColor = UIColor.MNGray
//        t.layer.cornerRadius = 2
//        t.layer.masksToBounds = true
        //        t.textAlignment = .left
        return t
    }()
    
    fileprivate var colorLabel:UILabel = {
        let l = MNLabel(customFont: .ProximaNovaRegular, withSize: 35)
        l.text = "Color"
        return l
    }()
    
    var taskTitle:String {
        get {
            return titleLabel.text!
        } set {
            titleLabel.text = newValue
        }
    }

    let colorCollection:UICollectionView = {
        let layout = ColorLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.borderColor = UIColor.darkGray.cgColor
        cv.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        cv.backgroundColor = UIColor.clear
//        cv.layer.cornerRadius = 2
//        cv.layer.masksToBounds = true
        
        
        //        cv.register(StepsControllerHeaderViewReusableView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "StepsHeader")
        return cv
    }()
    
    var doneButton:UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 4
        b.setFAIcon(icon: .FAThumbsUp, forState: .normal)
        b.alpha = 0
        return b
    }()
    
    var textBoxDoneButtonStack:UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    func dismissBox() {
        titleBox.resignFirstResponder()
    }
    

    
    
    override func viewDidLoad() {

        doneButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissBox)))
        
        colorCollection.delegate = self
        colorCollection.dataSource = self
        
        titleBox.delegate = self
        
        textBoxDoneButtonStack.insertArrangedSubview(titleBox, at: 0)
        textBoxDoneButtonStack.insertArrangedSubview(doneButton, at: 1)

        viewStack.insertArrangedSubview(titleLabel, at: 0)
        viewStack.insertArrangedSubview(textBoxDoneButtonStack, at: 1)
        viewStack.insertArrangedSubview(colorLabel, at: 2)
        viewStack.insertArrangedSubview(colorCollection, at: 3)
        
        view.backgroundColor = UIColor.MNDarkGray
        view.addSubview(viewStack)
    
        NSLayoutConstraint.activate([
            viewStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            viewStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            viewStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            viewStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            ])
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 70),
            textBoxDoneButtonStack.heightAnchor.constraint(equalToConstant: 60),
            colorLabel.heightAnchor.constraint(equalToConstant: 70),
            colorCollection.heightAnchor.constraint(equalToConstant: 300),
            
            doneButton.widthAnchor.constraint(equalToConstant: 80),
//            doneButton.heightAnchor.constraint(equalToConstant: <#T##CGFloat#>)
        
            ])
        
        
    }
    
    //collectionview datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        
        cell.color = colors[indexPath.item]
        cell.awakeFromNib()
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        return cell
    }
    
    
    //collectionview delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedColorIndex = indexPath.item
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: 0.65, y: 0.65)
            transform = transform.rotated(by: 5)
//            transform.rotate
            cell?.transform = transform
        }, completion: { finished in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
                var transform = CGAffineTransform.identity
                transform = transform.scaledBy(x: 1, y: 1)
                transform = transform.rotated(by: 0)
                cell?.transform = transform
            }, completion: nil)

        })
        changeColors()
    }
    
    func changeColors() {
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.textColor = self.colors[self.selectedColorIndex]
            self.colorLabel.textColor = self.colors[self.selectedColorIndex]
        })

    }
    
    

    
    
}
