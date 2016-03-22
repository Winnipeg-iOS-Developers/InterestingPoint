# Step 2: Show Pins on the Map

In this part, we are going to see to add some point of interest to our map. We will be using the `showAnnotations(annotations: [MKAnnotation], animated: Bool)` of the `MK Map View`. This method is taking an **array** of `MKAnnotation` as parameter which is defined as:

```swift
public protocol MKAnnotation : NSObjectProtocol {
    
    // Center latitude and longitude of the annotation view.
    // The implementation of this property must be KVO compliant.
    public var coordinate: CLLocationCoordinate2D { get }
    
    // Title and subtitle for use by selection UI.
    optional public var title: String? { get }
    optional public var subtitle: String? { get }
}
```

`MKAnnotation` is a **protocol** with a property **coordinate** and 2 optionals properties: **title** and **subtitle**.

Let's create our own object `POI` which adopt the `MKAnnotation` protocol:

```swift
import MapKit

class POI: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        subtitle: String?,
        coordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

```

This is basic, nothing special here, we keep the title and subtitle optionals and we implement the `init()` method of our class.

###### Addional content (this part hasn't be seend during the presentation) ######

We are going to simulate a service which is providing us the data (points of interest in this case) for our application. There is 2 important notions here: 

* Singleton pattern
* Lazy initialization

The `Singleton` is a pattern which allow us to create a single instance of a specific class. It allow us to be sure that we are always accessing the same instance of the class whenever we will need it, in `swift` we can perform it by using the `static` keyword which is defining a **property** or **method** related to the class itself rather than any instantiation of the class.

The `lazy initialization` is a memory management feature which allow us to delay a calculation process to the time we will need it, see more in the [Part III: Notions seen during the presentation](../part3/lazy.md).

So to create our service, we are going to use the `Singleton` pattern on a new class with a method which is returning an **array** of `POI`:

```swift
import CoreLocation

class POIService {
    static let sharedInstance = POIService()
    
    lazy var pointsOfInterest: Array<POI> = {
        return [
            POI(
                title: "First interesting place.",
                subtitle: "This place is great",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8519574378154,
                    longitude: -97.2117918551222
                )
            ),
            POI(
                title: "Second interesting place.",
                subtitle: "This place is alright",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.9040656356851,
                    longitude: -97.1168358331907
                )
            ),
            POI(
                title: "Third interesting place.",
                subtitle: "This place sucks",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.9508672072522,
                    longitude: -97.2422074558971
                )
            ),
            POI(
                title: "Fourth interesting place.",
                subtitle: "Have I been here before?",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8716259581715,
                    longitude: -97.0682061864028
                )
            ),
            POI(
                title: "Fifth interesting place.",
                subtitle: "I don't know where I am...",
                coordinate: CLLocationCoordinate2D(
                    latitude: 49.8141108489216,
                    longitude: -97.1298990909147
                )
            )
        ]
    }()
}
```

Finally, go back to your `POIViewController` and add the following:

```swift
import UIKit
import MapKit

class POIViewController: UIViewController {
    var poiService = POIService.sharedInstance
    ...
    override func viewDidLoad() {
        ...
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Get POIs
        let pois = poiService.pointsOfInterest
        
        // Add annotations to map
        mapView.showAnnotations(pois, animated: true)
    }
    ...
}
```