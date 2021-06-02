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
        static var objectId = ""
        static var key = ""
        static var firstname = ""
        static var lastname = ""
        static var createdAt = ""
    }
    
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case signUp
        case getLogginUserProfile
        case getStudentLocation
        case addStudentLocation
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            case .signUp: return "https://auth.udacity.com/sign-up"
            case .getLogginUserProfile: return Endpoints.base + "/users/" + Auth.key
            case .getStudentLocation: return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
            case .addStudentLocation: return Endpoints.base + "/StudentLocation"
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
        var request = URLRequest(url: Endpoints.login.url)
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
    // MARK: getLogginInUserProfile
        class func getLogginInUserProfile(completion: @escaping (UserProfile?, Error?) -> Void) {
            
            RequestCenter.taskForGetRequest(url: Endpoints.getLogginUserProfile.url, apiType: "Udacity", responseType: UserProfile.self) { (response, error) in
                if let response = response {
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                    print("add student location in udacity client \(response)")
                } else {
                    DispatchQueue.main.async {
                        completion(nil,error)
                    }
                }
            }
            
        }
// MARK: **********************************************************
    // MARK: Add/POST Student Location
    class func addStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaUrl: String, latitude: Double, longtitude: Double, completion: @escaping (Bool, Error?) -> Void) {

        taskPOSTRequest(url: Endpoints.addStudentLocation.url, body: StudentLocationRequest(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaUrl, latitude: latitude, longitude: longtitude), response: PostStudentLocationResponse.self) { (response, error) in
            if let response = response {
                Auth.objectId = response.objectId
                Auth.createdAt = response.createdAt
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
 
    }
  
// MARK: **********************************************************

    // MARK: Get Student Location
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
    
    class func taskPOSTRequest<Request: Encodable, Response: Decodable>(url: URL, body:Request, response: Response.Type, completionHandler: @escaping (Response?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let enconder = JSONEncoder()
        do {
            request.httpBody = try enconder.encode(body)
        } catch {
            DispatchQueue.main.async {
                completionHandler(nil, error)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
            }
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let object = try decoder.decode(response.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(object, nil)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                    }
                }
            }
        task.resume()
        }
    
}
