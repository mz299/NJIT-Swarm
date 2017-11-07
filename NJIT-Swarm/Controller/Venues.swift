//
//  Venues.swift
//  NJIT-Swarm
//
//  Created by Apoorva Reed on 11/4/17.
//  Copyright © 2017 Team4. All rights reserved.
//

import MapKit
import AddressBook

class Venue : NSObject, MKAnnotation
{
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    var subtitle: String?{
        return locationName
    }
    
}

