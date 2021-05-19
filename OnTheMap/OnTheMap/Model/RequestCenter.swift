    //
    //  RequestCenter.swift
    //  OnTheMap
    //
    //  Created by Pinar Unsal on 2021-05-18.
    //
    
    import Foundation
    
    class RequestCenter {
        // MARK: GET Request
        class func taskForGetRequest<ResponseType: Decodable>(url: URL, apiType: String, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
            
            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//
//
//            if apiType == "Udacity" {
//                request.addValue("application/json", forHTTPHeaderField: "Accept")
//                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            } else {
//                request.addValue("application/json", forHTTPHeaderField: "Accept")
//                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                print("im in parse else in the gettask")
//            }
            
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                if error != nil {
                    completion(nil, error)
                    print("cant get")
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil,error)
                        print("im in guard in the gettask")
                    }
                    return
                }
                do {
                    if apiType == "Udacity" {
                        let range = 5..<data.count
                        let newData = data.subdata(in: range)
                        let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                        DispatchQueue.main.async {
                            completion(responseObject, nil)
                        }
                    } else {
                        let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                        DispatchQueue.main.async {
                            completion(responseObject, nil)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil,error)
                        print("im in second catch in the gettask")
                    }
                }
            }
            task.resume()
        }
        
        // MARK: POST and PUT Request
        class func taskForPOSTRequest<ResponseType: Decodable> (url:URL, ResponseType:ResponseType.Type, apiType: String, httpMethod:String, body: String, completion: @escaping (ResponseType?, Error?) -> Void) {
            
            var request = URLRequest(url: url)
            if httpMethod == "POST" {
                request.httpMethod = "POST"
            } else {
                request.httpMethod = "PUT"
            }
            if apiType == "Udacity" {
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } else {
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            request.httpBody = body.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion(nil, error)
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                        
                    }
                    return
                }
                do {
                    if apiType == "Udacity" {
                        let range = 5..<data.count
                        let newData = data.subdata(in: range)
                        let responseObject = try JSONDecoder().decode(ResponseType.self, from: newData)
                        DispatchQueue.main.async {
                            completion(responseObject, nil)
                        }
                    } else {
                        let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                        DispatchQueue.main.async {
                            completion(responseObject, nil)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        }
        
    }
    
