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
    
    // Returns Array of POIs ordered by the shortest possible route which connects all pois starting from location parameter.
    func ordered(byShortestRouteToEachPOIStartingFrom location: CLLocation) -> [POI] {
        
        // Calculate all possible permutations, sorting by total distance.
        let sorted = permutations.sort { (first, second) in
            return first.totalDistance(startingFrom: location) < second.totalDistance(startingFrom: location)
        }
        
        // Return first or empty array.
        return sorted.first ?? [POI]()
    }
    
    // Return Array of POIs ordered by the nearest neighbour algorithm.
    func ordered(byNearestNeighbourStartingFrom location: CLLocation) -> [POI] {
        var scratch = Array(self)
        var result = [POI]()
        
        var previousLocation = location
        
        while scratch.count > 0 {
            scratch = scratch.ordered(byProximityTo: previousLocation)
            let nearest = scratch.removeFirst()
            result.append(nearest)
            previousLocation = nearest.location
        }
        
        return result
    }
    
    func totalDistance(startingFrom startingLocation: CLLocation) -> CLLocationDistance {
        var totalDistance: CLLocationDistance = 0.0
        
        // Start from passed in location
        var previousLocation = startingLocation
        
        // Add distance between each location and previous location to totalDistance.
        for poi in self {
            totalDistance += previousLocation.distanceFromLocation(poi.location)
            previousLocation = poi.location
        }
        
        return totalDistance
    }
}

extension SequenceType {
    /// Returns array of all possible order permutations.
    var permutations: Array<[Generator.Element]> {
        var scratch = Array(self) // This is a scratch space for Heap's algorithm
        var result = Array<[Generator.Element]>() // This will accumulate our result
        
        // Heap's algorithm
        func heap(n: Int) {
            if n == 1 {
                result.append(scratch)
                return
            }
            
            for i in 0..<n-1 {
                heap(n-1)
                let j = (n%2 == 1) ? 0 : i
                swap(&scratch[j], &scratch[n-1])
            }
            heap(n-1)
        }
        
        // Let's get started
        heap(scratch.count)
        
        print("Number of permutations: \(result.count)")
        
        // And return the result we built up
        return result
    }
}

public extension Double {
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        get { return Double(arc4random()) / 0xFFFFFFFF }
    }
    
    /// Returns random Double between min and max, inclusive.
    public static func random(min min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}