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
                title: "First interesting place.",
                subtitle: "This place is great",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8519574378154,
                    longitude: -97.2117918551222
                )
            ),
            POI(
                title: "Second interesting place.",
                subtitle: "This place is alright",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.9040656356851,
                    longitude: -97.1168358331907
                )
            ),
            POI(
                title: "Third interesting place.",
                subtitle: "This place sucks",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.9508672072522,
                    longitude: -97.2422074558971
                )
            ),
            POI(
                title: "Fourth interesting place.",
                subtitle: "Have I been here before?",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8716259581715,
                    longitude: -97.0682061864028
                )
            ),
            POI(
                title: "Fifth interesting place.",
                subtitle: "I don't know where I am...",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8141108489216,
                    longitude: -97.1298990909147
                )
            )
        ]
    }()
}