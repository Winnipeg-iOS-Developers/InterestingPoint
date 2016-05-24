# Chapter III: Implementing a detailled view controller

### Designing a segue with the storyboard

We will now implement our detailled view controller. Let's start by adding a *Detail Accessory* to our cells, this is where the transition to the detailled view will start.

Go to the *Main.storyboard* file, select the *poiCell* prototype and set its *Accessory* field to "Detail" in the *Attributes Inspector*. This will automatically add a detail icon to the right of the table view cells.

![illustration11](../art/illustration11.png)

Now it's time to design our detailled view. 

* Add a *Navigation Controller* component to your storyboard
* Delete its *Root View Controller* (it's by default a table view which is not what we want)
* Add a *View Controller* component to your storyboard
* <kbd>CTRL + DRAG</kbd> from your *Navigation Controller* to your *View Controller* and select the option "Relationship Segue: Root View Controller"
* Finally, <kbd>CTRL + DRAG</kbd> from your *poiCell* to your *Navigation Controller* and select the option "Accessory Action: Present Modally" (you are telling xCode that the Accessory from your *poiCell* should present the detailled view)

You just defined a segue connection in your storyboard. Select this segue (the connection between the main view and the new navigation controller) and rename it "showSegueVC" in the *Attributes Inspector*, this will help us to reference it in the code in the next part.

Let's add some design to our *detailled poi view*:

* Add a map view at the top of the view
  * Pin its trailing, leading and top spaces to the superview
  * Set its height equal to 200
* Add a vertical stack view under your map view (a stack view can manage a "stack of view" horizontally or vertically easily and prevent you from the pain of a "last edit constraint surgery")
  * In the *Attributes Inspector*, set its spacing to 8
  * Pin its trailing and leading spaces to the superview (the root view and not the map view)
  * Fix the vertical space between the map view and the stack view (default space should be 8)
* In the stack view, add 2 labels for the annotation title and subtitle and a label for its coordinate, all these component can be customized from the *Attributes Inspector* (for example, add a placeholder for the textfields)
* Finally add two *Bar Button Item* into the *Navigation Item* (by dragging them), one for each side (left and right). Rename the first one "Cancel" and the second one "Save" (they will be used for exiting this view)

That's it, from the storyboard, our detailled view has been set up. We now have to connect this new detailled view to our main view via the code.

### Connecting the new view

Let's create a view controller for our new detailled view. In your *controller* folder create a new file *SegueVC.swift*:

```swift
import UIKit

class SegueVC: UIViewController {
	
}
```

Once you defined your *SegueVC* controller, you can attribute it to the visual view controller in your storyboard (in the *Attributes Inspector*). Start then by connecting the four components to the code (Pass in *Assistant Editor* and drag and drop them to your controller just below the class declaration):

```swift
import UIKit
import MapKit

class SegueVC: UIViewController {
	@IBOutlet var mapView: MKMapView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var subtitleTextField: UITextField!
    @IBOutlet var coordinateLabel: UILabel!
}
```

We will configure 5 things in this controller:

```swift
class SegueVC: UIViewController, MKMapViewDelegate {
    // MARK: - Outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var subtitleTextField: UITextField!
    @IBOutlet var coordinateLabel: UILabel!
    
    // MARK: - Properties
    var poi: POI!
    
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
}
```

* First, we create a *poi property* which will be the reference of the selected poi in the main view. In the `viewDidLoad()` we ensure that this property has been correctly set up (`validateDependencies()`).
* Second, we configure the map view, we set the controller as its delegate and we center it on the selected pin (using the delegate method `showAnnotations()`).
* Finally, we configure the two text fields and the label by giving them the values of the selected pin.

Our detailled controller has been implemented, we now need to configure the segue in the main controller, we can do this by using a method inherited by *UIViewController* `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`:

```swift
// MARK: - Segues
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showSegueVC" {
        let navController = segue.destinationViewController as! UINavigationController
        let segueVC = navController.topViewController as! SegueVC
        let selectedCell = sender as! UITableViewCell
        let selectedIndexPath = tableView.indexPathForCell(selectedCell)!
        
        let poi = poiService.pointsOfInterest[selectedIndexPath.row]
        segueVC.poi = poi
    }
}
```

To configure the *Navigation Button Item* proceed like this:

* In the *Assistant Editor* <kbd>CTRL + DRAG</kbd> your "Save" button to the bottom of the Class. In the popup, select the type *Action Connection* type and name it. This code will handle a pressure on the save button:

```swift
@IBAction func saveTapped(sender: AnyObject) {
    poi.title = self.titleTextField.text
    poi.subtitle = self.subtitleTextField.text
    
    // TODO: Set identifier in storyboard for unwind segue.
    performSegueWithIdentifier("unwindToPOIViewController", sender: self)
}
```

This action call a method from the root view controller `performSegueWithIdentifier()` which must:

* Have to be defined in the *POIViewController*:

```swift
@IBAction func unwindToPOIViewController(unwindSegue: UIStoryboardSegue) {
    if let segueVC = unwindSegue.sourceViewController as? SegueVC {
        let poi = segueVC.poi

        // We deselect and reselect the poi in case its content has been updated in the detailled view
        mapView.deselectAnnotation(poi, animated: false)
        mapView.selectAnnotation(poi, animated: false)
        
        // We reload the corresponding row in the table view in case it has been updated in the detailled view
        if let index = poiService.pointsOfInterest.indexOf(poi) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
    }
}
```

* Have its identifier defined somewhere on the segues of your storyboards. Select the segue in the storyboard and set it *Identifier* to "unwindToPOIViewController" in the *Attributes Inspector*

And don't forget to link this method to the "Cancel" bar button in the storyboard with <kbd>CTRL + DRAG</kbd> (for this manipulation, the <kbd>CTRL + DRAG</kbd> must be done from the *cancel button* to the *exit* at the top of the visual view controller and by selecting the corresponding method you previsously implemented).