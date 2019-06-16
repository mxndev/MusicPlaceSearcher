//
//  MapViewModel.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 16/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import Foundation

class MapViewModel: MapViewModelBase {
    
    // singleton without dependency injection
    static let instance: MapViewModelBase = MapViewModel()
    
    weak var delegate: MapViewDelegate?
    
}
