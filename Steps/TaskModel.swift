//
//  TaskModel.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

struct TaskModel {
    var isMarked:Bool!
    var percentComplete:Double!

    var stepsComplete:String!
    var title:String!
    
    var isComplete:Bool!
    var steps:[StepModel]!
}

struct StepModel {
    var title:String!
    var isComplete:Bool!
}
