//
//  LogoutRequest.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-21.
//

import Foundation

struct LogoutRequest: Codable {
    let id: String
    let expiration: String
}
