//
//  StudentLocationRequest.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-19.
//

import Foundation

struct StudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
