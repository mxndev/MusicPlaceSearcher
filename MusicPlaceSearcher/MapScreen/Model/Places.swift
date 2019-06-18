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

struct LifeSpan: Codable {
    let begin: Date?
    let lifetime: Int?
    
    enum CodingKeys: String, CodingKey {
        case begin = "begin"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "rrrr-MM-dd"
        let beginString = try values.decodeIfPresent(String.self, forKey: .begin)
        if let beginStringDate = beginString {
            begin = dayTimePeriodFormatter.date(from: beginStringDate)
            dayTimePeriodFormatter.dateFormat = "rrrr"
            lifetime = Int(dayTimePeriodFormatter.string(from: begin!))! - 1990
        } else {
            begin = nil
            lifetime = nil
        }
    }
}
