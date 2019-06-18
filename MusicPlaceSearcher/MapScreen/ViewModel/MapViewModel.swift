//
//  MapViewModel.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 16/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import Foundation

class MapViewModel: MapViewModelBase {
    
    private let maximumOffset = 2 // maximum results per page
    
    // singleton without dependency injection
    static let instance: MapViewModelBase = MapViewModel()
    
    private let networkService: MusicPlacesServicesProtocol = MusicPlacesServices.instance
    
    var listOfPlaces: [Place] = []
    
    weak var delegate: MapViewDelegate?
    
    func loadData() {
        downloadPlaceData(query: "chi", itemsCounter: 0, loopCounter: 0)
    }
    
    func downloadPlaceData(query: String, itemsCounter: Int, loopCounter: Int) {
        self.networkService.getMusicPlaces(query: query, limit: maximumOffset, offset: loopCounter*maximumOffset) { (result: NetworkResult<PlacesResult>) in
            switch result {
            case .success(let places):
                places.places.forEach({ self.listOfPlaces.append($0)})
                if loopCounter*self.maximumOffset < places.count {
                    self.downloadPlaceData(query: query, itemsCounter: places.count, loopCounter: ( loopCounter + 1))
                } else {
                    self.filterByCoords(places: self.listOfPlaces)
                }
            default:
                break
            }
        }
    }
    
    func filterByCoords(places: [Place]) -> [Place] {
        return places
    }
}
