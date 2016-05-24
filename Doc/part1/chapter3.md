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

Let's add some design to our *detailled poi view*:

* Add a map view at the top of the view
  * Pin its trailing, leading and top spaces to the superview
  * Set its height equal to 200
* Add a vertical stack view under your map view (a stack view can manage a "stack of view" horizontally or vertically easily and prevent you from the pain of a "last edit constraint surgery")
  * In the *Attributes Inspector*, set its spacing to 8
  * Pin its trailing and leading spaces to the superview (the root view and not the map view)
  * Fix the vertical space between the map view and the stack view (default space should be 8)
* In the stack view, add 2 labels for the annotation title and subtitle and a label for its coordinate, all these component can be customized from the *Attributes Inspector* (for example, add a placeholder for the textfields)

That's it, from the storyboard, our detailled view has been set up. We now have to connect this new detailled view to our main view via the code.