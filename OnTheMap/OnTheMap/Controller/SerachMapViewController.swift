//
//  SerachMapViewController.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-22.
//

import UIKit
import MapKit

class SearchMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var locationString: String!
    var addLocationVC: AddLocationViewContoller!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchLocation()
    }
    
    func searchLocation() {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = locationString
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                let alertVC = UIAlertController(title: "Location not found", message: "Please input a valid location.", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alertVC, animated: true, completion: nil)
                return
            }
            
            let pin = MKPointAnnotation()
            pin.coordinate = response.mapItems[0].placemark.coordinate
            pin.title = response.mapItems[0].name
            self.mapView.addAnnotation(pin)
            self.mapView.setCenter(pin.coordinate, animated: true)
            let region = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func addLocationTapped(_ sender: Any) {
        self.addLocationVC.location = CGPoint(x: self.mapView.annotations[0].coordinate.latitude, y: self.mapView.annotations[0].coordinate.longitude)
        navigationController?.popViewController(animated: true)
        print("add location tapped")
    }
}
