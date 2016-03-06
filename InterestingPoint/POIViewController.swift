//
//  POIViewController.swift
//  InterestingPoint
//
//  Created by Jeffrey Fulton on 2016-03-05.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

import UIKit
import MapKit

class POIViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let locationManager = CLLocationManager()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        
        centerMapOnWinnipeg()
        
        setupTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupMapView()
        displayPOIAnnotationsOnMap()
    }
    
    // MARK: - Helpers
    
    func centerMapOnWinnipeg() {
        let winnipegCoord = CLLocationCoordinate2D(
            latitude: 49.8672610886807,
            longitude: -97.1576372488644
        )
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(
            winnipegCoord,
            60000,
            60000
        )
        
        mapView.setRegion(viewRegion, animated: false)
    }
    
    func displayPOIAnnotationsOnMap() {
        // Get POIs
        let poiService = POIService.sharedInstance
        let pois = poiService.pointsOfInterest
        
        // Add annotations to map
        mapView.showAnnotations(pois, animated: true)
    }

    func setupTableView() {
        // Blur tableView background
        let visualEffect = UIBlurEffect(style: .Light)
        let visualEffectView = UIVisualEffectView(effect: visualEffect)
        tableView.backgroundView = visualEffectView
    }
    
    func setupMapView() {
        mapView.layoutMargins.bottom = tableView.frame.height
    }

}
