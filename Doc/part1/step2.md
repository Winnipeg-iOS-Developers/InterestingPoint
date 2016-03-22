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