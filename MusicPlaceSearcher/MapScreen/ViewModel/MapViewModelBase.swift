//
//  MapViewModelBase.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 16/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import Foundation

protocol MapViewModelBase {
    var delegate: MapViewDelegate? { get set }
    
    func loadData()
}

protocol MapViewDelegate: class {
    func showPinsOnMap(places: [MusicPlace])
}
