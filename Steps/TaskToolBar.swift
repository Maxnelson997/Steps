//
//  TaskToolBar.swift
//  Steps
//
//  Created by Max Nelson on 8/30/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

//class TaskCollectionHeaderView:UICollectionReusableView {
//    var exists:Bool = false
//    let bar = TaskToolBar()
//    
//    override func awakeFromNib() {
//        if !exists {
//            exists = true
//            addSubview(bar)
//            NSLayoutConstraint.activate(bar.getConstraintsTo(view: self, withInsets: UIEdgeInsets.zero))
//        }
//    }
//}

class TaskToolBar:UIToolbar {
    
    func add() {deli.InsertTask()}
    func remove() {deli.RemoveTask()}
    
    var deli:TaskProtocol!
    
    let recycleImage = UIImageView(image: #imageLiteral(resourceName: "recycling-bin"), rect: CGRect(x: 0, y: 0, width: 26, height: 26))
    let plusImage = UIImageView(image: #imageLiteral(resourceName: "add-button"), rect: CGRect(x: 0, y: 0, width: 26, height: 26))
    var recycleButton:UIBarButtonItem!
    var plusButton:UIBarButtonItem!
    let flexspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    func PhaseTwo() {
        recycleImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.remove)))
        plusImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.add)))
        
        recycleButton = UIBarButtonItem(customView: recycleImage)
        plusButton = UIBarButtonItem(customView: plusImage)
        
        self.setItems([plusButton, flexspace, recycleButton], animated: true)
        self.barStyle = .blackOpaque
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        PhaseTwo()
    }
    
    init() {
        super.init(frame: .zero)
        PhaseTwo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
