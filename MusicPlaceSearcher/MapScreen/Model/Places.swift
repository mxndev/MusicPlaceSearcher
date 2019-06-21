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
    let coordinates: Coordinates?
    let life: LifeSpan?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case coordinates = "coordinates"
        case life = "life-span"
    }
}

struct Coordinates: Codable {
    let latitude: String?
    let longitude: String?
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
}

struct LifeSpan: Codable {
    let begin: Date?
    let lifetime: Int
    
    enum CodingKeys: String, CodingKey {
        case begin = "begin"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let beginString = try values.decodeIfPresent(String.self, forKey: .begin)
        if let beginStringDate = beginString, let dateWithLifetime = LifeSpan.calculateLifetime(beginString: beginStringDate) {
            begin = dateWithLifetime.0
            lifetime = dateWithLifetime.1
        } else {
            begin = nil
            lifetime = 0
        }
    }
    
    init(beginDateString: String) {
        if let dateWithLifetime = LifeSpan.calculateLifetime(beginString: beginDateString) {
            begin = dateWithLifetime.0
            lifetime = dateWithLifetime.1
        } else {
            begin = nil
            lifetime = 0
        }
    }
    
    static func calculateLifetime(beginString: String) -> (Date, Int)? { // (begin, lifetime)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "rrrr-MM-dd"
        if let parsedDate = dayTimePeriodFormatter.date(from: beginString) {
            dayTimePeriodFormatter.dateFormat = "rrrr"
            if let beginYear = Int(dayTimePeriodFormatter.string(from: parsedDate)) {
                return (parsedDate, beginYear - 1990)
            }
        } else {
            dayTimePeriodFormatter.dateFormat = "rrrr"
            if let parsedOnlyYear = dayTimePeriodFormatter.date(from: beginString) {
                if let beginYear = Int(dayTimePeriodFormatter.string(from: parsedOnlyYear)) {
                    return (parsedOnlyYear, beginYear - 1990)
                }
            }
        }
        return nil
    }
}
