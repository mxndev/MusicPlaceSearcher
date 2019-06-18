//
//  MusicPlace.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 19/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import Foundation
import MapKit

class MusicPlace: MKPointAnnotation {
    let lifetime: Int
    
    init(locationName: String, coordinate: CLLocationCoordinate2D, lifetime: Int) {
        self.lifetime = lifetime
        super.init()
        
        self.title = locationName
        self.coordinate = coordinate
    }
}
