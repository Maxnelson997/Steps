//
//  OptionSet.swift
//  Steps
//
//  Created by Max Nelson on 8/25/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

struct StackViewDirection: OptionSet {
    //bitmask value
    let rawValue:Int
    
    static let vertical = StackViewDirection(rawValue: 1)
    static let horizontal = StackViewDirection(rawValue: 2)
}
