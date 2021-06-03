//
//  LoginViewController.swift.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-17.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeToKeyboardNotification()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        setLogginIn(true)
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    // MARK: Login Tapped
    @IBAction func loginTapped(_ sender: Any) {
        // MARK: Error Check for the TextFields
        guard self.emailTextField.text != "" else {
            showAlert(message: "Empty Email", title: "Text fields cannot be empty!")
            return
        }
        guard self.passwordTextField.text != "" else {
            showAlert(message: "Empty Password", title: "Text fields cannot be empty!")
            return
        }
        setLogginIn(true)
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    // MARK: Login State
    func setLogginIn(_ logginIn: Bool) {
        DispatchQueue.main.async {
            logginIn ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
        
        setUI(firstTextField: emailTextField, secondTextField: passwordTextField, button: signupButton, logginIn: logginIn)
    }
    
    // MARK: Handle Login Response
    func handleLoginResponse(success: Bool, error: Error?) {
        setLogginIn(false)
        
        DispatchQueue.main.async {
            success ? self.performSegue(withIdentifier: "login", sender: nil) : self.showAlert(message: error?.localizedDescription ?? "", title: "Login Failed")
        }
    }
}
