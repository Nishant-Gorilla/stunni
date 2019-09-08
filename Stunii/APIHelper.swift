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
    
    class func isVipUser(userId:String, completion: @escaping completionClosure<Bool>) {
        let url = WebServicesURL.baseURL + WebServicesURL.isVipUser
        let param : [String: String] = ["userid":userId]
        APIManager.shared.getAPI(url: url,parameters: param) { (response, error) in
            var isVip: Bool = false
            if let data = response as? [String: Any] {
                if let isPremium = data["isPremium"] as? String {
                    isVip = isPremium == "No" ? false : true
                }
                completion(isVip, nil)
            }
            else {
                completion(false, error)
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
    
    class func getQrData(userId:String, qrCode:String, completion: @escaping completionClosure<[String:Any]>) {
        let url = WebServicesURL.baseURL + WebServicesURL.checkQr
        let parameters: [String: String] = [
            "mUserid":userId,
            "qrcodeid":qrCode
        ]
        APIManager.shared.getAPI(url: url, parameters: parameters) { (response, error) in
            if let data = response as? [String: Any] {
                completion(data, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func redeemDeal(parameters:[String : String], completion: @escaping completionClosure<[String:Any]>) {
        let url = WebServicesURL.baseURL + WebServicesURL.redeemDeal
        APIManager.shared.getAPI(url: url, parameters: parameters) { (response, error) in
            if let data = response as? [String: Any] {
                completion(data, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
    class func countDealLimit(id:String, completion: @escaping completionClosure<[String:Any]>) {
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.countDealLimit)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "dealId": id
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            var _error: String?
            var resultData: [String: Any]?
            if (response as? HTTPURLResponse) != nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    resultData = json as? [String : Any]
                }
                catch {
                    _error = error.localizedDescription
                }
            }else{
                _error = String(describing: error)
            }
            if resultData == nil {
                completion(nil,  error)
            } else {
                completion(resultData,  nil)
            }
        }
        mData.resume()
    }
    
    
    
    class func getDealDetail(id:String, completion: @escaping completionClosure<Deal>) {
        let url = WebServicesURL.baseURL + WebServicesURL.dealDetail + "/" + id
        APIManager.shared.getAPI(url: url) { (response, error) in
            if let data = response as? [String: Any],
                let dataObject = data["data"] as? [String: Any] {
                let deal = Mapper<Deal>().map(JSONObject: dataObject)
                if let similarDealsArray = data["category"] as? [[String: Any]] {
                    let similarDeals = Mapper<Deal>().mapArray(JSONArray:  similarDealsArray)
                    deal?.similarDeals  = similarDeals
                }
                completion(deal, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    
    
    
    class func login(email: String, password: String, completion: @escaping completionClosure<User>) {
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
    
    class func sendStripeToken(_ token: String,
                               completion: @escaping (Bool, String?)->(())) {
        let url = "http://108.61.175.63:40117/api/vipsubscription"//WebServicesURL.baseURL + WebServicesURL.stripeToken
        let params: [String: String] = [
            "emailuser": "zazazaud@gmail.com",//UserData.loggedInUser?.email ?? "",
            "userid": UserData.loggedInUser?._id ?? "",
            "name": UserData.loggedInUser?.fname ?? "",
            "mobile": UserData.loggedInUser?.phone_number ?? "",
            "lastname": UserData.loggedInUser?.lname ?? "",
            "type": "I",
            "stripetoken": token
        ]
        
        APIManager.shared.getAPI(url: url, parameters: params) { (response, error) in
            if let err = error {
                completion(false, err.localizedDescription)
            }
            else if let json = response as? [String: Any] {
                print(json)
                if let status = json["status"] as? String {
                    if status == "0" {
                        let message = json["message"] as? String
                        completion(false, message ?? "")
                    }
                    else {
                        completion(true, "Payment Successfull!")
                    }
                }
            }
        }
    }
    
    
    class func getPremiumOffers(completion: @escaping ((Any?, Error?)->())) {
        let url = WebServicesURL.baseURL + WebServicesURL.premiumOffers
        APIManager.shared.getAPI(url: url) { (response, error) in
            if let err = error {
                completion(nil, err)
            }
            else if let json = response as? [String: Any] {
                var result: ([Deal]?, String?) = (nil, nil)
                if let dealsArray = json["premium"] as? [[String: Any]] {
                    let deals = Mapper<Deal>().mapArray(JSONArray: dealsArray)
                    result.0 = deals
                }
                if let price = json["premiumPrice"] as? String {
                    result.1 = price
                }
                completion(result, nil)
            }
            completion(nil, nil)
        }
    }
    
    
    class func stuId(completion: @escaping (StuId?)->()) {
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.stuId)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserData.loggedInUser!.access_token!,
                         forHTTPHeaderField: "access_token")
        
        let session = URLSession.shared
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let _ = response as? HTTPURLResponse {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let _json = json as? [String: Any],
                        let createAt = _json["created_at"] as? String {
                        var stuId = StuId(date: createAt)
                        stuId.photo = _json["photo"] as? String
                        completion(stuId)
                    }
                }
                catch {
                    completion(nil)
                }
            }else{
                completion(nil)
            }
        }
        mData.resume()
    }
    
    func getCategoryDetail(id:String, completion: @escaping completionClosure<[String: Any]>) {
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.categoryDetail)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "categoryId": id
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            var _error: String?
            var dict: [String:Any] = [:]
            var deals:[Deal] = []
            var subCat: [SubCategory] = []
            if let res = response as? HTTPURLResponse {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let jsonArray = (json as? [String:Any])?["deals"] as? [[String:Any]] {
                        deals =  Mapper<Deal>().mapArray(JSONArray: jsonArray)
                    }
                    
                    if let jsonArray = (json as? [String:Any])?["subCategory"] as? [[String:Any]] {
                        subCat =  Mapper<SubCategory>().mapArray(JSONArray: jsonArray)
                    }
                    dict = ["deals":deals,"subCat":subCat]
                }
                catch {
                    _error = error.localizedDescription
                }
            }else{
                _error = String(describing: error)
            }
            DispatchQueue.main.async {
                if error == nil {
                    completion(dict,  nil)
                } else {
                    completion(nil,  error)
                }
            }
        }
        mData.resume()
    }
    
    
    func getSubCategoryDetail(id:String, completion: @escaping completionClosure<[Deal]>){
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.subCategoryDetail)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "subcategoryId": id
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            var _error: String?
            
            var deals:[Deal] = []
            if let res = response as? HTTPURLResponse {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let jsonArray = (json as? [String:Any])?["data"] as? [[String:Any]] {
                        deals =  Mapper<Deal>().mapArray(JSONArray: jsonArray)
                    }
                }
                catch {
                    _error = error.localizedDescription
                }
            }else{
                _error = String(describing: error)
            }
            DispatchQueue.main.async {
                if error == nil {
                    completion(deals,  nil)
                } else {
                    completion(nil,  error)
                }
            }
        }
        mData.resume()
    }
    
    func getProviderDetail(id:String, completion: @escaping completionClosure<[Deal]>) {
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.providerDetail)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "providerId": id
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            var _error: String?
            
            var deals:[Deal] = []
            if let res = response as? HTTPURLResponse {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let jsonArray = (json as? [String:Any])?["data"] as? [[String:Any]] {
                        deals =  Mapper<Deal>().mapArray(JSONArray: jsonArray)
                    }
                }
                catch {
                    _error = error.localizedDescription
                }
            }else{
                _error = String(describing: error)
            }
            DispatchQueue.main.async {
                if error == nil {
                    completion(deals,  nil)
                } else {
                    completion(nil,  error)
                }
            }
        }
        mData.resume()
    }
    
    func postDemand(parameters:[String: Any], completion: @escaping completionClosure<[String:Any]>) {
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.demandDeal )
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
            var dict: [String:Any] = [:]
            if let res = response as? HTTPURLResponse {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let  data = json as? [String:Any] {
                        dict = data
                    }
                }
                catch {
                    _error = error.localizedDescription
                }
            }else{
                _error = String(describing: error)
            }
            DispatchQueue.main.async {
                if error == nil {
                    completion(dict,  nil)
                } else {
                    completion(nil,  error)
                }
            }
        }
        mData.resume()
    }
    
}
