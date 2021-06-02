//
//  UserProfile.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-18.
//

import Foundation

struct UserProfile: Codable {
    let firstname: String
    let lastname: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case firstname = "first_name"
        case lastname = "last_name"
        case key
    }
}
