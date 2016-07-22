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
                title: "Angel's Avocados",
                subtitle: "No one's avocados are as nice as Angel's!",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8519574378154,
                    longitude: -97.2117918551222
                )
            ),
            POI(
                title: "Biff's Bagels",
                subtitle: "Best bagels in town!",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.893413,
                    longitude: -97.174958
                )
            ),
            POI(
                title: "Ernest's Enchiladas",
                subtitle: "Enchilada Extravaganza!",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8141108489216,
                    longitude: -97.1298990909147
                )
            ),
            POI(
                title: "Cathy's Cupcakes",
                subtitle: "Cathy puts the cup in cupcake!",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.9508672072522,
                    longitude: -97.2422074558971
                )
            ),
            POI(
                title: "Darlene's Dumplings",
                subtitle: "Down right delicious Dumplings!",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8716259581715,
                    longitude: -97.0682061864028
                )
            )
        ]
    }()
}