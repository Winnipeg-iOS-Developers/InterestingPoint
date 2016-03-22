# A possible solution to the Code Challenge

Here is one of the possible solution to the Code Challenge:

* We add the `startUpdatingLocation()` method of our **location manager** in the `viewDidLoad()` scope
* We implement the `CLLocationManger` protocol method: `locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)`
* We check the authorization state concerning the GPS use, if the user rejected the GPS use, we remind him/her that the application won't be able to display its location and we advise him/her to change the application setting (we can even redirect him to the application authorization menu):

```swift
import UIKit
import MapKit

class POIViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {    // <- CLLocationManagerDelegate protocol added
    ...
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self		// We set the delegate of the location manager
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()		// This method update the location of the user on the map
        
        centerMapOnWinnipeg()
        
        setupTableView()
    }

    ...
    
    // We check the authorization state, if it has been rejected we warn the user with the UIAlertActionController:
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                // Authorization is ok
            }
        case .NotDetermined:
            manager.requestWhenInUseAuthorization()
        case .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "The GPS feature has been disabled and we won't be able to display your location unless you modify the application setting...",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
```

And the illustration:

![illustration9](../illustrations/illustration9.png)