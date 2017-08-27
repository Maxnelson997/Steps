//
//  Model.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class Model {
    static let modelInstance = Model()
    private init() {}
    
    var tasks:[TaskModel] = [
        TaskModel(isMarked: false, percentComplete: 26, stepsComplete: "2", title: "ok we gettin somewhere..", isComplete: false, steps: [StepModel(title: "step one", isComplete: false),StepModel(title: "step two", isComplete: false)]),
        TaskModel(isMarked: false, percentComplete: 74, stepsComplete: "6", title: "ok finally", isComplete: false, steps: [StepModel(title: "step juan", isComplete: false),StepModel(title: "step of two", isComplete: false)]),
           TaskModel(isMarked: false, percentComplete: 74, stepsComplete: "6", title: "ok finally", isComplete: false, steps: [StepModel(title: "step juan", isComplete: false),StepModel(title: "step of two", isComplete: false)]),
                  TaskModel(isMarked: false, percentComplete: 74, stepsComplete: "6", title: "ok finally", isComplete: false, steps: [StepModel(title: "step juan", isComplete: false),StepModel(title: "step of two", isComplete: false)])
        ,       TaskModel(isMarked: false, percentComplete: 74, stepsComplete: "6", title: "ok finally", isComplete: false, steps: [StepModel(title: "step juan", isComplete: false),StepModel(title: "step of two", isComplete: false)]),
                       TaskModel(isMarked: false, percentComplete: 74, stepsComplete: "6", title: "ok finally", isComplete: false, steps: [StepModel(title: "step juan", isComplete: false),StepModel(title: "step of two", isComplete: false)]),
                              TaskModel(isMarked: false, percentComplete: 74, stepsComplete: "6", title: "ok finally", isComplete: false, steps: [StepModel(title: "step juan", isComplete: false),StepModel(title: "step of two", isComplete: false)])
    ]
    

    
//    
//    struct TaskModel {
//        var isMarked:Bool!
//        var percentComplete:String!
//        
//        var stepsComplete:String!
//        var title:String!
//        
//        var isComplete:Bool!
//        var steps:[StepModel]!
//    }
//    
//    struct StepModel {
//        var title:String!
//        var isComplete:Bool!
//    }

}
