//
//  MusicPlacesService.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 17/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import Foundation

protocol MusicPlacesServicesProtocol {
    func getMusicPlaces(query: String, limit: Int, offset: Int, completionHandler: @escaping (NetworkResult<PlacesResult>) -> Void)
}

class MusicPlacesServices: MusicPlacesServicesProtocol {
    
    static let instance: MusicPlacesServicesProtocol = MusicPlacesServices()
    
    private let sessionService: URLSessionService = URLSessionService.instance
    
    func getMusicPlaces(query: String, limit: Int, offset: Int, completionHandler: @escaping (NetworkResult<PlacesResult>) -> Void) {
        let placesRequest = MusicPlacesRouter.getMusicPlaces(query: query, limit: limit, offset: offset).request
        sessionService.executeURLRequest(apiRequest: placesRequest) { (result: NetworkResult<Data>) in
            let serializedResult: NetworkResult<PlacesResult> = result.decodeData()
            completionHandler(serializedResult)
        }
    }
}
