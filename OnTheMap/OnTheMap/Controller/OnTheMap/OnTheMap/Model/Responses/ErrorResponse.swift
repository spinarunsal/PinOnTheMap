//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-06-01.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let error: String
}
