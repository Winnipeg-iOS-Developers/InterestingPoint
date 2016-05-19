//
//  DelegationVC.swift
//  InterestingPoint
//
//  Created by Jeffrey Fulton on 2016-05-19.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

import UIKit
import MapKit

protocol DelegationVCDelegate {
    func delegationVCDidCancel(delegationVC: DelegationVC)
    func delegationVCDidSave(delegationVC: DelegationVC)
}

class DelegationVC: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var subtitleTextField: UITextField!
    @IBOutlet var coordinateLabel: UILabel!
    
    // MARK: - Properties
    
    var poi: POI!
    var delegate: DelegationVCDelegate!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validateDependencies()
        configureMapView()
        setLabels()
    }
    
    // MARK: - Helpers
    
    func validateDependencies() {
        guard poi != nil else {
            fatalError("\(self.dynamicType) did not meet poi dependency.")
        }
        
        guard delegate != nil else {
            fatalError("\(self.dynamicType) did not meet delegate dependency.")
        }
    }
    
    func configureMapView() {
        mapView.delegate = self
        mapView.showAnnotations([poi], animated: false)
    }
    
    func setLabels() {
        titleTextField.text = poi.title
        subtitleTextField.text = poi.subtitle
        coordinateLabel.text = "\(poi.coordinate.latitude), \(poi.coordinate.longitude)"
    }
    
    // MARK: - Actions
    
    @IBAction func cancelTapped(sender: AnyObject) {
        delegate.delegationVCDidCancel(self)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        poi.title = self.titleTextField.text
        poi.subtitle = self.subtitleTextField.text
        
        delegate.delegationVCDidSave(self)
    }

}
