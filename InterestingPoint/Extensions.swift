//
//  Extensions.swift
//  InterestingPoint
//
//  Created by Jeffrey Fulton on 2016-07-22.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

import CoreLocation

// Extend only SequenceTypes which contain instances of POI.
extension SequenceType where Generator.Element == POI {
    
    // Returns Array of POIs ordered by proximity to location parameter.
    func ordered(byProximityTo location: CLLocation) -> [POI] {
        return self.sort { (first, second) in
            return location.distanceFromLocation(first.location) < location.distanceFromLocation(second.location)
        }
    }
}