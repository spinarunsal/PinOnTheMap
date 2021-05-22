//
//  LocationsResponse.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-18.
//

import Foundation

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
    
    
    //    init(_ dictionary: [String: AnyObject]) {
    //        self.objectId = dictionary["objectId"] as? String ?? ""
    //        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
    //        self.firstName = dictionary["firstName"] as? String ?? ""
    //        self.lastName = dictionary["lastName"] as? String ?? ""
    //        self.mapString = dictionary["mapString"] as? String ?? ""
    //        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
    //        self.latitude = dictionary["latitude"] as? Double ?? 0.0
    //        self.longitude = dictionary["longitude"] as? Double ?? 0.0
    //        self.createdAt = dictionary["createdAt"] as? String ?? ""
    //        self.updatedAt = dictionary["updatedAt"] as? String ?? ""
    //       // self.ACL = dictionary["ACL"] as? String ?? ""
    //    }
    
    //    var udacityName: String {
    //        var name = ""
    //        if !firstName.isEmpty {
    //            name = firstName
    //        }
    //        if !lastName.isEmpty {
    //            if name.isEmpty {
    //                name = lastName
    //            } else {
    //                name += " \(lastName)"
    //            }
    //        }
    //        if name.isEmpty {
    //            name = "FirstName LastName"
    //        }
    //        return name
    //    }
}
