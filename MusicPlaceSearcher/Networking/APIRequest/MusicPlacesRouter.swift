//
//  MusicPlacesRouter.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 17/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import Foundation

enum MusicPlacesRouter {
    case getMusicPlaces(query: String, limit: Int, offset: Int)
}

extension MusicPlacesRouter {
    
    var request: APIRequest {
        switch self {
            case .getMusicPlaces(let query, let limit, let offset):
//                let params: Parameters = ["grant_type":"password", "username":username, "password":password]
                return APIRequest(method: .post, endpoint: "oauth/token/", parameters: nil)
        }
    }
}
