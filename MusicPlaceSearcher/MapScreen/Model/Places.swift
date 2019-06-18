//
//  Places.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 18/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import Foundation

struct PlacesResult: Codable {
    let count: Int
    let offset: Int
    let places: [Place]
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case offset = "offset"
        case places = "places"
    }
}

struct Place: Codable {
    let name: String
    let coordinates: Coord?
    let life: LifeSpan?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case coordinates = "coordinates"
        case life = "life-span"
    }
}

struct Coord: Codable {
    let latitude: String?
    let longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
}

struct LifeSpan: Codable
{
    let begin: String?
    let end: String?
    
    enum CodingKeys: String, CodingKey {
        case begin = "begin"
        case end = "end"
    }
}
