//
//  MapViewModelTests.swift
//  MusicPlaceSearcherTests
//
//  Created by Mikołaj Płachta on 21/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import XCTest
@testable import MusicPlaceSearcher

class MapViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test1FilterCoordinate() {
        // prepare data
        var places: [Place] = []
        places.append(Place(name: "test1", coordinates: nil, life: nil))
        places.append(Place(name: "test2", coordinates: Coordinates(latitude: "12", longitude: "24"), life: nil))
        places.append(Place(name: "test3", coordinates: Coordinates(latitude: "36", longitude: "76"), life: nil))
        places.append(Place(name: "test4", coordinates: nil, life: nil))
        
        // initi view model and filter places
        let instance = MapViewModel(places: places)
        instance.filterByCoords()
        
        let filteredPlaces = instance.listOfPlaces
        
        XCTAssertEqual(filteredPlaces.count, 2, "List of filtered places seems to be wrong")
    }
    
    func test2FilterCoordinate() {
        // prepare data
        var places: [Place] = []
        places.append(Place(name: "test1", coordinates: Coordinates(latitude: "5", longitude: "12"), life: nil))
        places.append(Place(name: "test2", coordinates: Coordinates(latitude: "12", longitude: "24"), life: nil))
        places.append(Place(name: "test3", coordinates: Coordinates(latitude: "36", longitude: "76"), life: nil))
        
        // initi view model and filter places
        let instance = MapViewModel(places: places)
        instance.filterByCoords()
        
        let filteredPlaces = instance.listOfPlaces
        
        XCTAssertEqual(filteredPlaces.count, 3, "List of filtered places seems to be wrong")
    }
    
    func test1FilterDate() {
        // prepare data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "rrrr-MM-dd"
        
        var places: [Place] = []
        places.append(Place(name: "test1", coordinates: nil, life: LifeSpan(beginDateString: "1988-01-02")))
        places.append(Place(name: "test2", coordinates: nil, life: LifeSpan(beginDateString: "1989-01-02")))
        places.append(Place(name: "test3", coordinates: nil, life: LifeSpan(beginDateString: "1990-01-02")))
        places.append(Place(name: "test4", coordinates: nil, life: LifeSpan(beginDateString: "1991-01-02")))
        
        // initi view model and filter places
        let instance = MapViewModel(places: places)
        instance.filterByDate()
        
        let filteredPlaces = instance.listOfPlaces
        
        XCTAssertEqual(filteredPlaces.count, 1, "List of filtered dates seems to be wrong")
    }
    
    func test2FilterDate() {
        // prepare data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "rrrr-MM-dd"
        
        var places: [Place] = []
        places.append(Place(name: "test1", coordinates: nil, life: nil))
        places.append(Place(name: "test2", coordinates: nil, life: LifeSpan(beginDateString: "1989-01-02")))
        places.append(Place(name: "test3", coordinates: nil, life: LifeSpan(beginDateString: "1991-01-02")))
        places.append(Place(name: "test4", coordinates: nil, life: nil))
        
        // initi view model and filter places
        let instance = MapViewModel(places: places)
        instance.filterByDate()
        
        let filteredPlaces = instance.listOfPlaces
        
        XCTAssertEqual(filteredPlaces.count, 1, "List of filtered dates seems to be wrong")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
