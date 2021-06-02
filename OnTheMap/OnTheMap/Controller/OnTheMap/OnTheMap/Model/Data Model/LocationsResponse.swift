//
//  LocationsResponse.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-18.
//

import Foundation
// Student Information Struct
struct LocationsResponse: Codable {
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let uniqueKey: String?
    let objectId: String?
    let updatedAt: String?
}
