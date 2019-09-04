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
        APIManager.shared.getAPI(url: url) { (response, error) in
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
        APIManager.shared.getAPI(url: url) { (response, error) in
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
    
    
    class func getAllJobs(completion: @escaping completionClosure<[Job]>) {
        let url = WebServicesURL.baseURL + WebServicesURL.jobs
        APIManager.shared.getAPI(url: url) { (response, error) in
            if let data = response as? [String: Any],
                let dataArray = data["data"] as? [[String: Any]]{
                let categories = Mapper<Job>().mapArray(JSONArray: dataArray)
                completion(categories, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    class func getAllProviders(completion: @escaping completionClosure<[Provider]>) {
        let url = WebServicesURL.baseURL + WebServicesURL.providers
        APIManager.shared.getAPI(url: url) { (response, error) in
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
    
    
    class func login(email: String, password: String, completion: @escaping completionClosure<User?>) {
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.signin)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            var _error: String?
            var user:User?
            if let res = response as? HTTPURLResponse {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    user =  Mapper<User>().map(JSON: json as! [String : Any])
                }
                catch {
                    _error = error.localizedDescription
                }
            }else{
                _error = String(describing: error)
            }
            if user?._id == nil {
                completion(nil,  nil)
            } else {
                completion(user,  error)
            }
            
        }
        mData.resume()
    }
    
    
    func signUp(parameters:[String:Any], completion: @escaping completionClosure<User?>){
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.signup)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            var _error: String?
            var user:User?
            if let res = response as? HTTPURLResponse {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    user =  Mapper<User>().map(JSON: json as! [String : Any])
                }
                catch {
                    _error = error.localizedDescription
                }
            }else{
                _error = String(describing: error)
            }
            completion(user,  error)
        }
        mData.resume()
    }
    
    
    func getJobDetail(jobId:String, completion: @escaping completionClosure<Job>) {
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.jobDetail)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "jobId": jobId
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            var _error: String?
            var job:Job?
            if let res = response as? HTTPURLResponse {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    job =  Mapper<Job>().map(JSON: (json as! [String : Any])["data"] as! [String : Any])
                }
                catch {
                    _error = error.localizedDescription
                }
            }else{
                _error = String(describing: error)
            }
            if job?.id == nil {
                completion(nil,  error)
            } else {
                completion(job,  error)
            }
            
        }
        mData.resume()
    }
    
    
    
    
}
