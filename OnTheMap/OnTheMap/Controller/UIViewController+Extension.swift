//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-18.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: Show Alert
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    // MARK: Open Link in Safari
    func openLink (_ url: String) {
        guard  let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showAlert(message: "Cannot open link.", title: "Invalid Link")
            return
        }
        UIApplication.shared.open(url,options: [:])
    }
    
    // MARK: LogOut Button Tapped
    
    
}
