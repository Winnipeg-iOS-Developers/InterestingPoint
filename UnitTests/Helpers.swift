//
//  Helpers.swift
//  InterestingPoint
//
//  Created by Jeffrey Fulton on 2016-07-22.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

@testable import InterestingPoint
import CoreLocation

struct Helpers {
    /// Returns a new Array of POI objects.
    static func unsortedPOIs() -> [POI] {
        return [
            POI(
                title: "Biff's Bagels",
                subtitle: "2nd row in tableview",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.893413,
                    longitude: -97.174958
                )
            ),
            POI(
                title: "Angel's Avocados (Nearest)",
                subtitle: "1st row in tableview",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8519574378154,
                    longitude: -97.2117918551222
                )
            ),
            POI(
                title: "Ernest's Enchiladas",
                subtitle: "3rd row in tableview",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8141108489216,
                    longitude: -97.1298990909147
                )
            )
        ]
    }
    
    static func sortedPOIs() -> [POI] {
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
                subtitle: "2nd row in tableview",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.893413,
                    longitude: -97.174958
                )
            ),
            POI(
                title: "Ernest's Enchiladas",
                subtitle: "3rd row in tableview",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8141108489216,
                    longitude: -97.1298990909147
                )
            )
        ]
    }
}
