//
//  MapViewModel.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 16/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import Foundation
import MapKit

class MapViewModel: MapViewModelBase {
    
    private let maximumOffset = 100 // maximum results per page
    
    // singleton without dependency injection
    static let instance: MapViewModelBase = MapViewModel(places: [])
    
    // main constructor
    init(places: [Place]) {
        listOfPlaces = places
    }
    
    private let networkService: MusicPlacesServicesProtocol = MusicPlacesServices.instance
    
    var listOfPlaces: [Place]
    
    weak var delegate: MapViewDelegate?
    
    func loadData(query: String) {
        self.listOfPlaces.removeAll()
        downloadPlaceData(query: query, itemsCounter: 0, loopCounter: 0)
    }
    
    func downloadPlaceData(query: String, itemsCounter: Int, loopCounter: Int) {
        self.networkService.getMusicPlaces(query: query, limit: maximumOffset, offset: loopCounter*maximumOffset) { (result: NetworkResult<PlacesResult>) in
            switch result {
                case .success(let places):
                    places.places.forEach({ self.listOfPlaces.append($0)})
                    if loopCounter*self.maximumOffset < places.count {
                        self.downloadPlaceData(query: query, itemsCounter: places.count, loopCounter: ( loopCounter + 1))
                    } else {
                        // all data downloaded, filter data
                        self.filterByCoords()
                        self.filterByDate()
                        
                        // generate pins on map
                        if self.listOfPlaces.count > 0 {
                            self.delegate?.showPinsOnMap(places: self.listOfPlaces.map({
                                guard let lifetime = $0.life?.lifetime, let coordinates = $0.coordinates, let latitudeString = coordinates.latitude, let longitudeString = coordinates.longitude, let latitude = Double(latitudeString), let longitude = Double(longitudeString) else { return MusicPlace(locationName: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), lifetime: -1) }
                                return MusicPlace(locationName: $0.name, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), lifetime: lifetime)
                            }))
                        } else {
                            self.delegate?.showNoResultError()
                        }
                    }
                case .failure(let error):
                    if error == .NoInternetConnection {
                        self.delegate?.showNoInternetConnectionError()
                    } else {
                        self.delegate?.showDownloadingError()
                    }
            }
        }
    }
    
    func filterByCoords() {
        listOfPlaces = listOfPlaces.filter({ $0.coordinates != nil })
    }
    
    func filterByDate() {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "rrrr-MM-dd"
        listOfPlaces = listOfPlaces.filter({ $0.life != nil }).filter({ $0.life?.begin != nil }).filter({
            guard let lifetime = $0.life?.lifetime else { return false }
            return lifetime > 0 })
    }
}
