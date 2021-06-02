//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-18.
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}

struct LoginRequestPair: Codable {
    let udacity: [LoginRequest]
}
