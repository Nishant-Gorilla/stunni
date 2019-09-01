//
//  APIHelper.swift
//  Stunii
//
//  Created by Zap.Danish on 15/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import ObjectMapper

class APIHelper {
    
    typealias completionClosure<T> = ((T?, Error?) -> ())
    class func getAllDeals(completion: @escaping completionClosure<[HomeData]>) {
        let url = WebServicesURL.baseURL + WebServicesURL.home
        APIManager.getAPI(url: url) { (response, error) in
             if let data = response as? [String: Any],
                let dataArray = data["data"] as? [[String: Any]]{
                let allDeals = Mapper<HomeData>().mapArray(JSONArray: dataArray)
                completion(allDeals, nil)
            }
             else {
                completion(nil, error)
            }
        }
    }
    
    class func getAllCategories(completion: @escaping completionClosure<[Category]>) {
        let url = WebServicesURL.baseURL + WebServicesURL.category
        APIManager.getAPI(url: url) { (response, error) in
            if let data = response as? [String: Any],
                let dataArray = data["data"] as? [[String: Any]]{
                let categories = Mapper<Category>().mapArray(JSONArray: dataArray)
                completion(categories, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    class func getAllProviders(completion: @escaping completionClosure<[Provider]>) {
        let url = WebServicesURL.baseURL + WebServicesURL.providers
        APIManager.getAPI(url: url) { (response, error) in
            if let data = response as? [String: Any],
                let dataArray = data["data"] as? [[String: Any]]{
                let providers = Mapper<Provider>().mapArray(JSONArray: dataArray)
                completion(providers, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    
}
