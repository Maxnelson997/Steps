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
    

    var tasks:[TaskModel] = []
    var tasksIncomplete:[TaskModel] = []
    var tasksComplete:[TaskModel] = []
}
