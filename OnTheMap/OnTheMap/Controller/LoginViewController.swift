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
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        setLogginIn(true)
        UIApplication.shared.open(UdacityClient.Endpoints.signUp.url, options: [:], completionHandler: nil)
    }
    // MARK: Login Tapped
    @IBAction func loginTapped(_ sender: Any) {
        setLogginIn(true)
        UdacityClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
 
    // MARK: Login State
    func setLogginIn(_ logginIn: Bool) {
        if logginIn{
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        setUI(logginIn)
    }
    
    func setUI(_ logginIn: Bool) {
        emailTextField.isEnabled = !logginIn
        passwordTextField.isEnabled = !logginIn
        signupButton.isEnabled = !logginIn
    }
    
    // MARK: Handle Login Response
    func handleLoginResponse(success: Bool, error: Error?) {
        setLogginIn(false)
        if success {
            DispatchQueue.main.async {
            self.performSegue(withIdentifier: "login", sender: nil)
                
            }
        } else {
            showAlert(message: error?.localizedDescription ?? "", title: "Login Failed")
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failure", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }


}

