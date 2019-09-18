//
//  ApiManager.swift
//  GruntWork
//
//  Created by appzorro on 1/10/18.
//  Copyright © 2018 Appzorro. All rights reserved.
//

import Foundation
import Alamofire


class ApiManager {
    private let manager = NetworkReachabilityManager(host: "www.apple.com")

    static let apiObject = ApiManager()
    var loaderView = UIView()

    private init() {

    }

    
    func isNetworkReachable() -> Bool {
        return manager?.isReachable ?? false
    }
    
    func APIPost(action:String,parameters:Parameters!,animation:Bool = true,getData:@escaping (NSDictionary) -> ()) {
        
        let url = WebServicesURL.baseURL + action
        print(url,parameters)
      
        Alamofire.request(url, method: .post,parameters: parameters).responseJSON { response in
            print("🌍", response.request!)
            print(parameters)
            print(response.result.value as Any)
            
            if let JSON = response.result.value as? NSDictionary {
                getData(JSON)
                
               
            }else{
                getData([:])

                if  response.error != nil
                {
                    return
                }
            }
        }
    }
    func APIGet(parameters:Parameters!,animation:Bool = true,getData:@escaping (NSDictionary) -> ()) {
     
        let url = WebServicesURL.baseURL + WebServicesURL.countDealLimit
        Alamofire.request(url, method: .get,parameters: parameters).responseJSON { response in
            print("🌍", response.request!)
            print(parameters)
            print(response.result.value as Any)
            
            if let JSON = response.result.value as? NSDictionary {
                if let response = JSON.value(forKey: "response") as? NSDictionary{
                    
                    getData(response)
                    
                }
                
            }else{
                getData([:])

                if  response.error != nil
                {
                    return
                }
            }
            
        }
    }
   

}
