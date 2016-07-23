//
//  POIViewControllerTests.swift
//  InterestingPoint
//
//  Created by Jeffrey Fulton on 2016-07-22.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

import XCTest
@testable import InterestingPoint

class POIViewControllerTests: XCTestCase {
    
    // MARK: - Stored Properties
    
    var poiViewController: POIViewController!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Load POIViewController from Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        poiViewController = storyboard.instantiateInitialViewController() as! POIViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testControllerIsLoadedForTesting() {
        XCTAssertNotNil(poiViewController)
    }
    
    func testPoisAreLoadedFromPoiProviderOnViewDidLoad() {
        let expected = TestHelper.makePois()
        
        // Create and assign mock PoiProvider.
        struct MockPoiProvider: PoiProvider {
            var pois: [POI]
            
            func fetchPOIs(queue queue: NSOperationQueue, completion: (Result<POI>) -> ()) {
                let result = Result.success(pois)
                queue.addOperationWithBlock { completion(result) }
            }
        }
        
        let mockPoiProvider = MockPoiProvider(pois: expected)
        poiViewController.poiProvider = mockPoiProvider
        
        // We need an test expectation because the load happens asynchronously... which makes me feel like maybe I shouldn't be testing this in the first place. Oh well, this is just a demo!
        let expectation = expectationWithDescription("testPoisAreLoadedFromPoiProviderOnViewDidLoad")
        
        // Trigger viewDidLoad()
        let _ = poiViewController.view
        
        // Delay Assertion to allow async fetch to complete, should only take 1 tick of the run loop; which is why a delay of 0.0 works.
        delay(inSeconds: 0.0) {
            // Assertions
            XCTAssertEqual(expected, self.poiViewController.pois)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    
    
    func testAlertControllerIsPresentedOnError() {
        let expectedError = Error.UnitTest
        
        // Create and assign MockPoiProvider.
        struct MockPoiProvider: PoiProvider {
            var error: Error
            
            func fetchPOIs(queue queue: NSOperationQueue, completion: (Result<POI>) -> ()) {
                let result = Result<POI>.failure(error)
                queue.addOperationWithBlock { completion(result) }
            }
        }
        
        let mockPoiProvider = MockPoiProvider(error: expectedError)
        poiViewController.poiProvider = mockPoiProvider
        
        
        // Create and assign MockAlertProvider.
        class MockAlertProvider: AlertProvider {
            var errorPresented: ErrorType?
            var viewControllerToPresentFrom: UIViewController?
            
            func present(error: ErrorType, from viewController: UIViewController) {
                errorPresented = error
                viewControllerToPresentFrom = viewController
            }
        }
        
        let mockAlertProvider = MockAlertProvider()
        poiViewController.alertProvider = mockAlertProvider
        
        // Expectation required because loading happend asynchronously.
        let expectation = expectationWithDescription("testAlertControllerIsPresentedOnError")
        
        // Trigger viewDidLoad()
        let _ = poiViewController.view
        
        // Delay Assertion to allow async fetch to complete, should only take 1 tick of the run loop; which is why a delay of 0.0 works.
        delay(inSeconds: 0.0) {
            // Assertions
            XCTAssertNotNil(mockAlertProvider.errorPresented)
            
            guard let actualError = mockAlertProvider.errorPresented as? Error else {
                XCTFail("ErrorPresented should have been instance of Error.")
                return
            }
            
            XCTAssertEqual(expectedError, actualError)
            
            XCTAssertNotNil(mockAlertProvider.viewControllerToPresentFrom)
            
            guard let actualViewController = mockAlertProvider.viewControllerToPresentFrom else {
                XCTFail("viewControllerToPresentFrom should have been valid instance.")
                return
            }
            
            XCTAssertEqual(self.poiViewController, actualViewController)
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
}