//
//  Protocol.swift
//  Steps
//
//  Created by Max Nelson on 8/29/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

protocol StepProtocol {
    func SetStepStatus(at: Int, status: Bool)
}

protocol TaskProtocol {
    func InsertTask()
    func RemoveTask()
}
