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
        self.searchTextView.delegate = self
        self.searchTextView.returnKeyType = .done
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressed(sender: UIButton!) {
        executeLoadingPlacesData()
    }
}

extension MapViewController: MapViewDelegate {
    func showPinsOnMap(places: [MusicPlace]) {
        loadingView.isHidden = true
        
        for point in mapView.annotations {
            mapView.removeAnnotation(point)
        }
        
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
    
    func showNoResultError() {
        loadingView.isHidden = true
        let alertController = UIAlertController(title: "Sorry, no results!", message: "Try another one query.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
    
    func showNoInternetConnectionError() {
        loadingView.isHidden = true
        let alertController = UIAlertController(title: "Sorry, no internet connection!", message: "Try again later", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
    
    func showNoTextError() {
        loadingView.isHidden = true
        let alertController = UIAlertController(title: "Sorry, no entered text!", message: "First you must enter search query text.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
    
    func showDownloadingError() {
        loadingView.isHidden = true
        let alertController = UIAlertController(title: "Sorry, error occured. Try again later!", message: "Try again later", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let radius: Double = pow(10, 7)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextView.resignFirstResponder()
        executeLoadingPlacesData()
        return true
    }
    
    func executeLoadingPlacesData() {
        if let text = searchTextView.text, text != "" {
            loadingView.isHidden = false
            viewModel.loadData(query: text)
        } else {
            self.showNoTextError()
        }
    }
}
