//
//  Enumerations.swift
//  InterestingPoint
//
//  Created by Jeffrey Fulton on 2016-07-22.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

import Foundation

enum Result<T: SequenceType> {
    case failure(ErrorType)
    case success(T)
}

