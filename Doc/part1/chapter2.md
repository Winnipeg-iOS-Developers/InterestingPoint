# Chapter II: Implementing the main view of your application

### Additional requirement for the built-in map view

At this point, if you are running the applicaiton, xCode should be reporting the following error:

> Terminating app due to uncaught exception 'NSInvalidUnarchiveOperationException', reason: 'Could not instantiate class named MKMapView'

This error reminds you that the *Interface Builder* is not fully doing the work while dragging a map view component within a graphic view controller of your storyboard. Indeed, you also need to link the *MapKit.framework* to your controller, you can do this can be done in the *General* pannel of your project:

* Select your project in the *Project Navigator*
* Select the target of your project
* In the *Linked Frameworks and Libraries* search and add the *MapKit* framework.

![illustration6](../art/illustration6.png)

It leads you to a second error (which does not actually crash your application):

> Trying to start MapKit location updates without prompting for location authorization. Must call -[CLLocationManager requestWhenInUseAuthorization] or -[CLLocationManager requestAlwaysAuthorization] first.

Remember when you checked the *User Location* in the *Attributes Inspector* of the map view? That was a way to ask to xCode to manage the user location automatically. The problem is that xCode won't do all the job for you, you need to work with him to make this feature available.

Let's start by adding the basic method of any view controller to your *POIViewController*, `viewDidLoad()`:

```swift
import UIKit

class POIViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
```

`viewDidLoad()` is automatically called when your view controller has been... loaded. This is where you will put your code usually.

The error reported by xCode ask you to implement the method `requestWhenInUseAuthorization` (or `requestAlwaysAuthorization`). These methods can be called from a *CLLocationManager* of the *MapKit*. The difference between the two methods is that the first one tell the user you are going to use his/her device GPS feature only when the application state is *active* while the second one will ask for the feature even when the application is in the *background*. For the purpose of this tutorial, we only need to run the GPS when the application is *active*.

To be able to use the *MapKit* component, ou need to import the library at the top of your file, just under the *UIKit* import:

```swift
import UIKit
import MapKit
```

Then, you have to declare an instance of *CLLocationManager* and use this instance to call the required method:

```swift
class POIViewController: UIViewController {
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
    }
}
```

But this is not enough. This is due to Apple'culture which require that you inform the user about what you are going to do through your application (especially when you are using personal data such as GPS location). By doing some search in the documentation, you will find the following:

> NSLocationWhenInUseUsageDescription

> NSLocationWhenInUseUsageDescription (String - iOS) describes the reason why the app accesses the user’s location normally while running in the foreground. Include this key when your app uses location services to track the user’s current location directly. This key does not support using location services to monitor regions or monitor the user’s location using the significant location change service. The system includes the value of this key in the alert panel displayed to the user when requesting permission to use location services.

> This key is required when you use the requestWhenInUseAuthorization method of the CLLocationManager class to request authorization for location services. If the key is not present when you call the requestWhenInUseAuthorization method without including this key, the system ignores your request.

> This key is supported in iOS 8.0 and later. If your Info.plist file includes both this key and the NSLocationUsageDescription key, the system uses this key and ignores the NSLocationUsageDescription key.

So you need to add this key-value to your *Info.plist* file and add a new entry *NSLocationWhenInUseUsageDescription* with a **String** type and write the message you want to display to inform the user about the GPS usage:

![illustration7](../art/illustration7.png)

Run the application and accept the request for using your GPS, you should now be able to see your position on the map (At this state, your application has an invisible table view on the bottom part of your map)