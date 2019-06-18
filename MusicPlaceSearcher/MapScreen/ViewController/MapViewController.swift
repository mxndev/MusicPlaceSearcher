//
//  MapViewController.swift
//  MusicPlaceSearcher
//
//  Created by Mikołaj Płachta on 16/06/2019.
//  Copyright © 2019 Mikołaj Płachta. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var searchTextView: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var loadingView: UIView!
    
    fileprivate var viewModel: MapViewModelBase
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = MapViewModel.instance
        super.init(coder: aDecoder)
        viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MapViewController: MapViewDelegate {
    func showPinsOnMap(places: [MusicPlace]) {
        places.forEach({
            let point = $0
            
            if mapView.annotations.count == 0 {
                // if point is first one
                self.centerMapOnLocation(location: CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude))
            }
            
            mapView.addAnnotation(point)
            
            // remove point after lifetime
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(point.lifetime)) {
                    self.mapView.removeAnnotation(point)
                
            }
        })
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let radius: Double = pow(10, 7)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
