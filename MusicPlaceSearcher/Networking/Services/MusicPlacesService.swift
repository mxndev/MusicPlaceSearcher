//
//  MusicPlacesService.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 17/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import Foundation

protocol MusicPlacesServicesProtocol {
    func getMusicPlaces(query: String, limit: Int, offset: Int, completionHandler: @escaping (NetworkResult<TokenInfo>) -> Void)
}

class MusicPlacesServices: MusicPlacesServicesProtocol {
    
    private let sessionService: URLSessionService = URLSessionService()
    
    func getMusicPlaces(query: String, limit: Int, offset: Int, completionHandler: @escaping (NetworkResult<TokenInfo>) -> Void) {
        let placesRequest = MusicPlacesRouter.getMusicPlaces(query: query, limit: limit, offset: offset).request
        sessionService.executeURLRequest(apiRequest: placesRequest) { (result: NetworkResult<Data>) in
            let serializedResult: NetworkResult<TokenInfo> = result.decodeData()
            completionHandler(serializedResult)
        }
    }
}
