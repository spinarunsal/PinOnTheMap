//
//  AddLocationViewContoller.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-21.
//

import Foundation
import UIKit
import MapKit
class AddLocationViewContoller: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addLocationButton: UIButton!
    var location: CGPoint!
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var mediaURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideMapview()
        self.locationTextField.delegate = self
        self.websiteTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        hideMapview()
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeToKeyboardNotification()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Find Location
    
    @IBAction func findLocationTapped(_ sender: Any) {
        unsubscribeToKeyboardNotification()
        activityIndicator.startAnimating()
        // MARK: Error Check for the TextFields
        
        guard self.locationTextField.text != "" else {
            showAlert(message: "Empty Location", title: "Text fields cannot be empty!")
            return
        }
        guard self.websiteTextField.text != "" else {
            showAlert(message: "Empty URL", title: "Text fields cannot be empty!")
            return
        }
        
        activityIndicator.stopAnimating()
        
        searchLocation()
        showMapView()
    }
    
    func handlePOSTLocationResponse(result: Bool, error: Error?) {
        if result {
            self.locationTextField.text = ""
            self.websiteTextField.text = ""
            self.location = nil
            DispatchQueue.main.async {
                self.showAlert(message: "Congratulation", title: "Your location has been added succesfully.")
            }
        } else {
            DispatchQueue.main.async {
                self.showAlert(message: "Something Went Wrong", title: "Your location has NOT been added.")
            }
        }
    }
    
    //upload location
    func getUserData(completion: @escaping(Bool, Error?) -> Void) {
        UdacityClient.getLogginInUserProfile { (userData, error) in
            if let userData = userData {
                self.uniqueKey = userData.key
                self.firstName = userData.firstname
                self.lastName = userData.lastname
                
                completion(true,nil)
            } else {
                completion(false,error)
            }
        }
    }
    
    func handleGetUserData(success: Bool, error: Error?) {
        if success {
            UdacityClient.addStudentLocation(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: locationTextField.text!, mediaUrl: websiteTextField.text!, latitude: Double(location.x), longtitude: Double(location.y), completion: handlePOSTLocationResponse(result:error:))
        } else {
            showAlert(message: "Error", title: "Error Posting Location")
        }
    }
    
    // MARK: Map View
    func hideMapview() {
        mapView.isHidden = true
        addLocationButton.isHidden = true
        view.addSubview(mapView)
        view.addSubview(addLocationButton)
    }
    
    func showMapView() {
        mapView.isHidden = false
        addLocationButton.isHidden = false
        unsubscribeToKeyboardNotification()
    }
    
    func searchLocation() {
        activityIndicator.startAnimating()
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = locationTextField.text
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let response = response else {
                let alertVC = UIAlertController(title: "Location not found", message: "Please input a valid location.", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                    self.hideMapview()
                }))
                self.present(alertVC, animated: true, completion: nil)
                return
            }
            
            let pin = MKPointAnnotation()
            pin.coordinate = response.mapItems[0].placemark.coordinate
            pin.title = response.mapItems[0].name
            print("\(String(describing: response.mapItems[0].name)) Name****")
            print("Auth name \(UdacityClient.Auth.firstname)")
            self.mapView.addAnnotation(pin)
            self.mapView.setCenter(pin.coordinate, animated: true)
            let region = MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
        activityIndicator.stopAnimating()
    }
    
    @IBAction func addLocationTapped(_ sender: Any) {
        
        activityIndicator.startAnimating()
        self.location = CGPoint(x: self.mapView.annotations[0].coordinate.latitude, y: self.mapView.annotations[0].coordinate.longitude)
        hideMapview()
        getUserData(completion: handleGetUserData(success:error:))
        print("add location tapped")
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
