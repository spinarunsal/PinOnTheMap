//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-18.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
    
    
    struct Account: Codable {
        let registered: Bool
        let key: String
    }
}
