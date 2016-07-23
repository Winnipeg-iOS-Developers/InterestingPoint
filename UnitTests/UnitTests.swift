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
    
    // MARK: - Stored Properties
    
    // Set default values in setUp()
    var pois: [POI]!
    var location: CLLocation!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        pois = TestHelper.makePois()
        location = TestHelper.makeLocation()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Unit Tests
    
    func testPOIsCanBeOrderedByPromixityToLocation() {
        // Input values are being set in setUp().
        
        // Expected
        let expected = [
            TestHelper.makeAngelsPOI(),
            TestHelper.makeBiffsPOI(),
            TestHelper.makeErnestsPOI(),
            TestHelper.makeDarlenesPOI(),
            TestHelper.makeCathysPOI()
        ]
        
        // Actual
        let actual = pois.ordered(byProximityTo: location)
        
        // Assertions
        XCTAssertNotEqual(pois, actual) // Make sure the input doesn't pass the test.
        XCTAssertEqual(expected, actual)
    }
    
    func testPOIsOrderedByShortestRouteFromLocation() {
        // Input values are being set in setUp().
        
        // Expected
        let expected = [
            TestHelper.makeDarlenesPOI(),
            TestHelper.makeErnestsPOI(),
            TestHelper.makeAngelsPOI(),
            TestHelper.makeBiffsPOI(),
            TestHelper.makeCathysPOI()
        ]
        
        // Actual
        let actual = pois.ordered(byShortestRouteToEachPOIStartingFrom: location)
        
        // Assertions
        XCTAssertNotEqual(pois, actual) // Make sure the input doesn't pass the test.
        XCTAssertEqual(expected, actual)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceOfOrderByShortestRoute() {
        let randomPOIs = TestHelper.makeRandomPOIs(count: 5)
        
        self.measureBlock {
            // Put the code you want to measure the time of here.
            randomPOIs.ordered(byShortestRouteToEachPOIStartingFrom: self.location)
        }
    }
    
    func testPerformanceOfOrderByNearestNeighbour() {
        let randomPOIs = TestHelper.makeRandomPOIs(count: 100)
        
        self.measureBlock {
            // Put the code you want to measure the time of here.
            randomPOIs.ordered(byNearestNeighbourStartingFrom: self.location)
        }
    }
    
    // MARK: - Async Tests
    
    func testAsyncOrderByShortestRoute() {
        // Input values are being set in setUp().
        
        // Expected result
        let expected = [
            TestHelper.makeDarlenesPOI(),
            TestHelper.makeErnestsPOI(),
            TestHelper.makeAngelsPOI(),
            TestHelper.makeBiffsPOI(),
            TestHelper.makeCathysPOI()
        ]
        
        // Create an XCTestExpectation in order to run test asynchronously.
        let expectation = expectationWithDescription("Execute completion closure.")
        
        // Perform Async operation.
        pois.ordered(byShortestRouteToEachPOIStartingFrom: location, queue: .mainQueue()) { (result) in
            switch result {
            case .failure: XCTFail("Expected success")
            case .success(let actual):
                // Assertions
                XCTAssertNotEqual(self.pois, actual) // Make sure initial values would not pass the test.
                XCTAssertEqual(expected, actual)
            }
            
            // Fulfill the expectation in order to signal the tests are complete.
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
}
