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
                    // all data downloaded
                    self.listOfPlaces = self.filterByCoords(places: self.listOfPlaces)
                    self.listOfPlaces = self.filterByDate(places: self.listOfPlaces)
                    self.delegate?.showPinsOnMap(places: self.listOfPlaces.map({ MusicPlace(locationName: $0.name, coordinate: CLLocationCoordinate2D(latitude: Double(($0.coordinates?.latitude)!)!, longitude: Double(($0.coordinates?.longitude)!)!), lifetime: ($0.life?.lifetime)!)}))
                    let ss = self.listOfPlaces
                }
            default:
                break
            }
        }
    }
    
    func filterByCoords(places: [Place]) -> [Place] {
        return places.filter({ $0.coordinates != nil })
    }
    
    func filterByDate(places: [Place]) -> [Place] {
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "rrrr-MM-dd"
        return places.filter({ $0.life != nil }).filter({ $0.life?.begin != nil }).filter({ ($0.life!.begin)! > dayTimePeriodFormatter.date(from: "1990-01-01")!})
    }
}
