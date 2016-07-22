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
    
    lazy var pointsOfInterest: Array<POI> = {
        return [
            POI(
                title: "Angel's Avocados (Nearest)",
                subtitle: "1st row in tableview",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8519574378154,
                    longitude: -97.2117918551222
                )
            ),
            POI(
                title: "Biff's Bagels",
                subtitle: "??? row in tableview",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.893413,
                    longitude: -97.174958
                )
            ),
            POI(
                title: "Cathy's Cupcakes (Farthest)",
                subtitle: "Last row in tableview",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.9508672072522,
                    longitude: -97.2422074558971
                )
            ),
            POI(
                title: "Darlene's Dumplings",
                subtitle: "??? row in tableview",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8716259581715,
                    longitude: -97.0682061864028
                )
            ),
            POI(
                title: "Ernest's Enchiladas",
                subtitle: "??? row in tableview",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8141108489216,
                    longitude: -97.1298990909147
                )
            )
        ]
    }()
    
    
    /// Return Array of POIs sorted by accending proximity to location param.
    func pointsOfInterestOrderedByProximity(to location: CLLocation) -> [POI] {
        return pointsOfInterest.sort { (first, second) in
            return location.distanceFromLocation(first.location) < location.distanceFromLocation(second.location)
        }
    }
}




