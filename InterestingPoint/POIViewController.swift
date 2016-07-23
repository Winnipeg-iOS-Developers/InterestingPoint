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
    MKMapViewDelegate,
    DelegationVCDelegate
{
    // MARK: - Dependencies
    var alertProvider: AlertProvider = AlertService.sharedInstance
    var poiProvider: PoiProvider = PoiService.sharedInstance
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    var pois = [POI]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        
        centerMapOnWinnipeg()
        
        setupTableView()
        
        reloadPOIsFromDataSource()
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
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
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
    
    func reloadPOIsFromDataSource() {
        // Fetch POIs asynchronously from Network or Disk.
        poiProvider.fetchPOIs(queue: .mainQueue()) { (result) in
            // Switch on result enumeration; Error or POIs are accessed via Swift enum associated values.
            switch result {
            case .failure(let error):
                // Display error in AlertView via alertProvider
                self.alertProvider.present(error, from: self)
                
            case .success(let pois):
                self.pois = pois
            }
        }
    }
    
    func updateUIForPOI(poi: POI) {
        // MapView annotation
        mapView.deselectAnnotation(poi, animated: false)
        mapView.selectAnnotation(poi, animated: false)
        
        // TableView row
        if let index = pois.indexOf(poi) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
    
    func updateUI() {
        displayPOIAnnotationsOnMap()
        drawRouteOverlaysOnMap()
        tableView.reloadData()
    }
    
    func drawRouteOverlaysOnMap() {
        // Remove existing overlays
        mapView.removeOverlays(mapView.overlays)
        
        // Get array of coordinates from POIs
        var coordinates = pois.map { $0.coordinate }
        
        // Add UserLocation coordinate if available.
        if let userLocationCoordinate = mapView.userLocation.location?.coordinate {
            coordinates.insert(userLocationCoordinate, atIndex: 0)
        }
        
        // Add coordinates as MKPolyline overlay
        let overlay = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        mapView.addOverlay(overlay, level: .AboveRoads)
    }

    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pois.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("poiCell", forIndexPath: indexPath)
        
        let poi = pois[indexPath.row]
        
        cell.textLabel?.text = poi.title
        cell.detailTextLabel?.text = poi.subtitle
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let poi = pois[indexPath.row]
        mapView.selectAnnotation(poi, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        // Get pois sorted by proximity to user location.
        guard let location = userLocation.location else { return }
        
        // Sort by proximity to current location.
//        pois = pois.ordered(byProximityTo: location)
        
        // Sort by shortest route from current location to all POIs.
//        pois = pois.ordered(byShortestRouteToEachPOIStartingFrom: location)
        
        // Get pois sorted by nearest neighbour alogrithm.
        pois = pois.ordered(byNearestNeighbourStartingFrom: location)
        
        // Update UI
        updateUI()
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        // Return nil (default) for all annotations which are not POIs. i.e. MKUserLocation
        guard annotation is POI else { return nil }
        
        // Memory optimization
        let reuseIdentifier = "pinAnnotationView"
        let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView ??
            MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        annotationView.canShowCallout = true
        
        // Directions Button
        let leftButton = UIButton(type: .Custom)
        let image = UIImage(named: "Car Icon")
        leftButton.setImage(image, forState: .Normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        leftButton.tintColor = UIColor.whiteColor()
        leftButton.backgroundColor = self.view.tintColor
        annotationView.leftCalloutAccessoryView = leftButton

        
        // Info Button
        let rightButton = UIButton(type: .DetailDisclosure)
        annotationView.rightCalloutAccessoryView = rightButton
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        guard let selectedPOI = view.annotation as? POI else { return }
        guard let index = pois.indexOf(selectedPOI) else { return }
    
        // Select cell at index
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
    }
    
    func mapView(
        mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl)
    {
        let poi = view.annotation as! POI
        
        // Take separate actions for left & right accessory controls.
        
        // Directions
        if control == view.leftCalloutAccessoryView {
            getDirectionsForPOI(poi)
        }
        
        // DelegationVC
        if control == view.rightCalloutAccessoryView {
            // Instantiate view controller from storyboard.
            let storyboard = UIStoryboard(name: "Main", bundle: nil )
            let navController = storyboard.instantiateViewControllerWithIdentifier(
                "DelegationNC") as! UINavigationController
            
            // Configure DelegationVC before presenting.
            let delegationVC = navController.topViewController as! DelegationVC
            
            delegationVC.poi = poi
            delegationVC.delegate = self
            
            // Present as modal
            presentViewController(navController, animated: true, completion: nil)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let lineView = MKPolylineRenderer(overlay: overlay)
        lineView.strokeColor = .blueColor()
        return lineView
    }
    
    // MARK: - DelegationVCDelegate
    
    func delegationVCDidCancel(delegationVC: DelegationVC) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delegationVCDidSave(delegationVC: DelegationVC) {
        let poi = delegationVC.poi
        updateUIForPOI(poi)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSegueVC" {
            let navController = segue.destinationViewController as! UINavigationController
            let segueVC = navController.topViewController as! SegueVC
            let selectedCell = sender as! UITableViewCell
            let selectedIndexPath = tableView.indexPathForCell(selectedCell)!
            
            let poi = pois[selectedIndexPath.row]
            segueVC.poi = poi
        }
    }
    
    @IBAction func unwindToPOIViewController(unwindSegue: UIStoryboardSegue) {
        if let segueVC = unwindSegue.sourceViewController as? SegueVC {
            let poi = segueVC.poi
            updateUIForPOI(poi)
        }
    }
    
    // MARK: - Directions
    
    func getDirectionsForPOI(poi: POI) {
        let placemark = MKPlacemark(
            coordinate: poi.coordinate,
            addressDictionary: nil
        )
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = poi.title
        
        mapItem.openInMapsWithLaunchOptions([
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}
