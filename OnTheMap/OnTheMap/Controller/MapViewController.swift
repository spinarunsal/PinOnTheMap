//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-21.
//

import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshPin: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var locations = [LocationsResponse]()
    var annotaions = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getStudentPins()
//        activityIndicator.bringSubviewToFront(self.view)
//        activityIndicator.center = self.view.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentPins()
    }
    // MARK: Logout tapped
    @IBAction func logoutButtonTapped(_ sender: Any) {
        self.activityIndicator.startAnimating()
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @IBAction func refreshPinTapped(_ sender: Any) {
        getStudentPins()
    }
    
    @IBAction func addLocationButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addLocation", sender: nil)
    }
    func getStudentPins() {
        self.activityIndicator.startAnimating()
        UdacityClient.getStudentLocations { (locations, error) in
            self.mapView.removeAnnotations(self.annotaions)
            self.annotaions.removeAll()
            self.locations = locations ?? []
            for dictionary in locations ?? []{
                let lat = CLLocationDegrees(dictionary.latitude ?? 0.0)
                let long = CLLocationDegrees(dictionary.longitude ?? 0.0)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary.firstName
                let last = dictionary.lastName
                let mediaUrl = dictionary.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first ?? "empty") \(last ?? "empty")"
                annotation.subtitle = mediaUrl
                self.annotaions.append(annotation)
            }
            
            DispatchQueue.main.async {
                //hata olursa check here
                self.mapView.addAnnotations(self.annotaions)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                openLink(toOpen )
            }
        }
    }
}
