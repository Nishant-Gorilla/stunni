//
//  APIManager.swift
//  Stunii
//
//  Created by Uday Bhateja on 23/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Alamofire

class APIManager: NSObject {
    
    override init() {
        super.init()
        APIManager.setHeader(value: "Content-Type", forKey: "application/json")
    }
    
    //MARK: Header
    static private var headers: [String: String] = [:]
    
    class func setHeader(value: String, forKey key: String) {
        headers[key] = value
    }
    class func removeHeaderValueFor(key: String) {
        headers.removeValue(forKey: key)
    }
    
    //MARK: GET, POST
    typealias completionClosure = ((Any?, Error?)->())
    
    class func getAPI(url: String, completion: @escaping completionClosure) {
        Alamofire.request(url).responseJSON { (response) in
            completion(response.value, response.error)
        }
    }
    class func postApI(url: String, parameters: [String: Any] = [:], completion: @escaping completionClosure) {
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
               
        }
    }
}


//MARK:- APIClient
class APIClient {
    
    func initialize() {
        APIManager.setHeader(value: "Content-Type", forKey: "application/json")
    }
    
}
