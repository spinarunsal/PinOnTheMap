//
//  AddLocationViewContoller.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-21.
//

import Foundation
import UIKit
class AddLocationViewContoller: UIViewController {
    

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var location: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let _ =  location {
            self.addLocation()
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Find Location
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchMapVC = segue.destination as! SearchMapViewController
        searchMapVC.locationString = self.locationTextField.text
        searchMapVC.addLocationVC = self
        
    }
    @IBAction func findLocationTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        guard self.locationTextField.text != "" else {
            showAlert(message: "Empty Location", title: "Text fields cannot be empty!")
            return
        }
        guard self.websiteTextField.text != "" else {
            showAlert(message: "Empty URL", title: "Text fields cannot be empty!")
            return
        }
        //performSegue(withIdentifier: "findLocation", sender: nil)
        activityIndicator.stopAnimating()
    }
    
    func handlePOSTLocationResponse(result: Bool, error: Error?) {
        if result {
            self.locationTextField.text = ""
            self.websiteTextField.text = ""
            self.location = nil
            showAlert(message: "Congratulation", title: "Your location has been added succesfully.")
        } else {
            showAlert(message: "Something Went Wrong", title: "Your location has NOT been added.")
        }
    }
    //upload location
    func addLocation() {
        activityIndicator.startAnimating()
        let requestLocation = StudentLocationRequest(uniqueKey: "", firstName: "", lastName: "", mapString: self.locationTextField.text!, mediaURL: self.websiteTextField.text!, latitude: Double(self.location.x), longitude: Double(self.location.y))
        UdacityClient.addStudentLocation(information: requestLocation, completion: handlePOSTLocationResponse(result:error:))
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
}
