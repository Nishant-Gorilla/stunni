//
//  APIManager.swift
//  Stunii
//
//  Created by Uday Bhateja on 23/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Alamofire

class APIManager: NSObject {
    
    static let shared = APIManager()
    
    override init() {
        super.init()
        setHeader(value: "Content-Type", forKey: "application/json")
        setHeader(
            value: "Authorization",
            forKey: "YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz")
    }
    
    //MARK: Header
    private var headers: [String: String] = [:]
    
    func setHeader(value: String, forKey key: String) {
        headers[key] = value
    }
     func removeHeaderValueFor(key: String) {
        headers.removeValue(forKey: key)
    }
    
    //MARK: GET, POST
    typealias completionClosure = ((Any?, Error?)->())
    
    func getAPI(url: String, completion: @escaping completionClosure) {
        Alamofire.request(url).responseJSON { (response) in
            completion(response.value, response.error)
        }
    }
    
    
    func postApI(url: String, parameters: [String: Any] = [:], completion: @escaping completionClosure) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
            .validate(statusCode: 0...999)
            .responseJSON { (response) in
            completion(response.value, response.error)
        }
    }
}


//MARK:- APIClient
class APIClient {
    
    func initialize() {
        APIManager.shared.setHeader(value: "Content-Type", forKey: "application/json")
    }
    
}
