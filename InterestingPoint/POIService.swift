//
//  PointOfInterestService.swift
//  InterestingPoint
//
//  Created by Jeffrey Fulton on 2016-03-04.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

import CoreLocation

class POIService {
    static let sharedInstance = POIService()
    
    /// Asynchonously fetch POIs from disk or network which can take multiple seconds to complete.
    /// Completion handler executes on provided queue.
    func fetchPOIs(queue queue: NSOperationQueue, completion: (Result<[POI]>)->()) {
        
        // Simulate network or disk I/O lag, then return results via completion handler.
        delay(inSeconds: 1) {
            let pois = TestHelper.makePois()
            let result = Result.success(pois)
            queue.addOperationWithBlock { completion(result) }
        }
    }
}