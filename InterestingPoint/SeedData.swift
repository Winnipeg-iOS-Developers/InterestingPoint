//
//  SeedData.swift
//  InterestingPoint
//
//  Created by Jeffrey Fulton on 2016-07-23.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

import CoreLocation

struct SeedData {
    
    /// Return new Array of test POIs.
    static func makePois() -> [POI] {
        return [
            makeAngelsPOI(),
            makeBiffsPOI(),
            makeErnestsPOI(),
            makeCathysPOI(),
            makeDarlenesPOI()
        ]
    }
    
    /// Return a new CLLocation with default values.
    static func makeLocation() -> CLLocation {
        return CLLocation(
            latitude: 49.85827,
            longitude: -97.157637
        )
    }
    
    // MARK: - Seed POIs as static functions to make sorting easier.
    
    static func makeAngelsPOI() -> POI {
        return POI(
            title: "Angel's Avocados",
            subtitle: "No one's avocados are as nice as Angel's!",
            coordinate: CLLocationCoordinate2D(
                latitude: 49.8519574378154,
                longitude: -97.2117918551222
            )
        )
    }
    
    static func makeBiffsPOI() -> POI {
        return POI(
            title: "Biff's Bagels",
            subtitle: "Best bagels in town!",
            coordinate: CLLocationCoordinate2D(
                latitude: 49.893413,
                longitude: -97.174958
            )
        )
    }
    
    static func makeErnestsPOI() -> POI {
        return POI(
            title: "Ernest's Enchiladas",
            subtitle: "Enchilada Extravaganza!",
            coordinate: CLLocationCoordinate2D(
                latitude: 49.8141108489216,
                longitude: -97.1298990909147
            )
        )
    }
    
    static func makeCathysPOI() -> POI {
        return POI(
            title: "Cathy's Cupcakes",
            subtitle: "Cathy puts the cup in cupcake!",
            coordinate: CLLocationCoordinate2D(
                latitude: 49.9508672072522,
                longitude: -97.2422074558971
            )
        )
    }
    
    static func makeDarlenesPOI() -> POI {
        return POI(
            title: "Darlene's Dumplings",
            subtitle: "Down right delicious Dumplings!",
            coordinate: CLLocationCoordinate2D(
                latitude: 49.8716259581715,
                longitude: -97.0682061864028
            )
        )
    }
    
    static func makeRandomPOIs(count count: Int) -> [POI] {
        let pois = (0..<count).map { _ in
            return makeRandomPOI()
        }
        
        return pois
    }
    
    static func makeRandomPOI() -> POI {
        return POI(
            title: "Randomly generated POI",
            subtitle: "For Testing purposes only",
            coordinate: CLLocationCoordinate2D(
                latitude: Double.random(min: 49, max: 49.9),
                longitude: Double.random(min: -97, max: -98)
            )
        )
    }
}
