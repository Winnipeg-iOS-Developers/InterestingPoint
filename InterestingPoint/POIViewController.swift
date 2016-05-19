//
//  POIViewController.swift
//  InterestingPoint
//
//  Created by Jeffrey Fulton on 2016-03-05.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

import UIKit
import MapKit

class POIViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    MKMapViewDelegate
{
    // MARK: - Dependencies
    var poiService = POIService.sharedInstance
    
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
        
        mapView.delegate = self
        
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
        let pois = poiService.pointsOfInterest
        
        // Add annotations to map
        mapView.showAnnotations(pois, animated: true)
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Blur tableView background
        let visualEffect = UIBlurEffect(style: .Light)
        let visualEffectView = UIVisualEffectView(effect: visualEffect)
        tableView.backgroundView = visualEffectView
    }
    
    func setupMapView() {
        mapView.layoutMargins.bottom = tableView.frame.height
    }
    
    func reloadUIForPOI(poi: POI) {
        // MapView annotation
        mapView.deselectAnnotation(poi, animated: false)
        mapView.selectAnnotation(poi, animated: false)
        
        // TableView row
        if let index = poiService.pointsOfInterest.indexOf(poi) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }

    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poiService.pointsOfInterest.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("poiCell", forIndexPath: indexPath)
        
        let poi = poiService.pointsOfInterest[indexPath.row]
        
        cell.textLabel?.text = poi.title
        cell.detailTextLabel?.text = poi.subtitle
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let poi = poiService.pointsOfInterest[indexPath.row]
        mapView.selectAnnotation(poi, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // Return nil (default) for all annotations which are not POIs. i.e. MKUserLocation
        guard annotation is POI else { return nil }
        
        // Memory optimization
        let reuseIdentifier = "pinAnnotationView"
        let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView ??
            MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        annotationView.canShowCallout = true
        
        // TODO: Add Directions button
        
        // Info Button
        let rightButton = UIButton(type: .DetailDisclosure)
        annotationView.rightCalloutAccessoryView = rightButton
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        guard let selectedPOI = view.annotation as? POI else { return }
        guard let index = poiService.pointsOfInterest.indexOf(selectedPOI) else { return }
    
        // Select cell at index
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
    }
    
    func mapView(
        mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl)
    {
        // TODO: Take separate actions for left & right accessory controls.
        
        // Instantiate view controller from storyboard.
        let storyboard = UIStoryboard(name: "Main", bundle: nil )
        let navController = storyboard.instantiateViewControllerWithIdentifier(
            "DelegationNC") as! UINavigationController
        
        // TODO: Configure DelegationVC before presenting.
        
        
        // Present as modal
        presentViewController(navController, animated: true, completion: nil)
    }
}
