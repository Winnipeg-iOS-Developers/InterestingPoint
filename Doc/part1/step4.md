# Step 4: Update MapView's Visible Region

So our application is going well, but something is a little weird... the view is actually centering on the screen's device rather than the visible region!

To fix this, we are going to ask the map view to update it's height according to the space taken by the table view, asking this to the map view require that the table view has already been displayed, that's why we will add our code in the `viewDidAppear` scope:

```swift
mapView.layoutMargins.bottom = tableView.frame.height
```
That's it, pretty simple right?