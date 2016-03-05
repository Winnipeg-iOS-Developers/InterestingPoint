//
//  POI.swift
//  InterestingPoint
//
//  Created by Jeffrey Fulton on 2016-03-04.
//  Copyright © 2016 Jeffrey Fulton. All rights reserved.
//

import MapKit

class POI {
    var title: String
    var subtitle: String
    var coordinate: CLLocationCoordinate2D
    
    init(
        title: String,
        subtitle: String,
        coordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
