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
    var poiService = POIService.sharedInstance
    
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
        pois = poiService.pointsOfInterest
    }
    
    func reloadUIForPOI(poi: POI) {
        // MapView annotation
        mapView.deselectAnnotation(poi, animated: false)
        mapView.selectAnnotation(poi, animated: false)
        
        // TableView row
        if let index = pois.indexOf(poi) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
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
    
    // MARK: DelegationVCDelegate
    
    func delegationVCDidCancel(delegationVC: DelegationVC) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delegationVCDidSave(delegationVC: DelegationVC) {
        let poi = delegationVC.poi
        reloadUIForPOI(poi)
        
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
            reloadUIForPOI(poi)
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
