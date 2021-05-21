//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Pinar Unsal on 2021-05-18.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId: String? = nil
        static var expiration: String? = nil
        static var key = ""
        static var firstname = ""
        static var lastname = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case logout
        case signUp
        case getLogginUserProfile
        case getStudentLocation
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            case .logout: return Endpoints.base + "/session"
            case .signUp: return "https://auth.udacity.com/sign-up"
            case .getLogginUserProfile: return Endpoints.base + "/users/" + Auth.key
            case .getStudentLocation: return Endpoints.base + "/StudentLocation?order=-updatedAt"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK: *Login
    class func login(username: String, password: String, completion: @escaping (Bool,Error?) -> Void) {
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        RequestCenter.taskForPOSTRequest(url: Endpoints.login.url, ResponseType: LoginResponse.self, apiType: "Udacity", httpMethod:"POST", body: body) {
            (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.key = response.account.key
                
                completion(true,nil)
                print("true")
            } else {
                completion(false,error)
                print("false000")
            }
        }
    }
    //MARK: *Logout
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
            print("LoggingOut Error")
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    
    
    }
    
    class func getLogginInUserProfile(completion: @escaping (Bool, Error?) -> Void) {
        RequestCenter.taskForGetRequest(url: Endpoints.getLogginUserProfile.url, apiType: "Udacity", responseType: UserProfile.self) { (response, error) in
            if let response = response {
                print("First Name : \(response.firstname) && Last Name : \(response.lastname) && Full Name: \(response.nickname)")
                Auth.firstname = response.firstname
                Auth.lastname = response.lastname
                
                completion(true,nil)
            } else {
                print("Failed to get user's profile.")
                completion(false,error)
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping ([LocationsResponse]?, Error?) -> Void) {
        RequestCenter.taskForGetRequest(url: Endpoints.getStudentLocation.url, apiType: "Parse", responseType: StudentLocation.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
            } else {
                print("no student location")
                completion([],error)
            }
        }
    }
    
}
