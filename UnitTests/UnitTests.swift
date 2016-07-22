//
//  UnitTests.swift
//  UnitTests
//
//  Created by Jeffrey Fulton on 2016-07-22.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

import XCTest
import CoreLocation
@testable import InterestingPoint

class UnitTests: XCTestCase {
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testPOIsCanBeOrderedByPromixityToLocation() {
        // Input
        let unsortedPOIs = [
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
        
        // User Location
        let location = CLLocation(
            latitude: 49.85827,
            longitude: -97.157637
        )
        
        // Expected
        let expected = [
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
        
        // Actual
        let actual = unsortedPOIs.ordered(byProximityTo: location)
        
        // Assert
        XCTAssertEqual(expected, actual)
    }
    
    func testPOIsOrderedByShortestRouteFromLocation() {
        // Input
        let pois = [
            POI(
                title: "Angel's Avocados (Nearest)",
                subtitle: "Nones avocados are as nice as Angel's!",
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
            )
        ]
        
        // User Location
        let location = CLLocation(
            latitude: 49.85827,
            longitude: -97.157637
        )
        
        // Expected
        let expected = [
            POI(
                title: "Biff's Bagels",
                subtitle: "Best bagels in town!",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.893413,
                    longitude: -97.174958
                )
            ),
            POI(
                title: "Angel's Avocados (Nearest)",
                subtitle: "Nones avocados are as nice as Angel's!",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8519574378154,
                    longitude: -97.2117918551222
                )
            ),
            POI(
                title: "Ernest's Enchiladas",
                subtitle: "Enchilada Extravaganza!",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8141108489216,
                    longitude: -97.1298990909147
                )
            )
        ]
        
        // Actual
        let actual = pois.ordered(byShortestRouteToEachPOIStartingFrom: location)
        
        // Assertions
        XCTAssertNotEqual(pois, actual) // Make sure the input doesn't pass the test.
        XCTAssertEqual(expected, actual)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
