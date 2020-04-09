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
    class func getAllDeals(param:[String:String],completion: @escaping completionClosure<[HomeData]>) {
        let url = WebServicesURL.baseURL + WebServicesURL.home
        print(url)
        print(param)
//        let param : [String:String] = ["isActive":"true","page":"1","type":"1","lat":"\(locValue == nil ? 0.0 : locValue.latitude)","lng":"\(locValue == nil ? 0.0 : locValue.latitude)"]
        print(param)
        APIManager.shared.getAPI(url: url,parameters:param) { (response, error) in
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
            print(response)
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
    
   class func submitReferral(_ referBy: String,
                               completion: @escaping (Bool, String?)->(())) {
        let url = "https://api.stunii.com/reference?"
        let params: [String: String] = [
            "email": UserData.loggedInUser?.email ?? "",
            "userid": UserData.loggedInUser?._id ?? "",
            "fullname": UserData.loggedInUser?.fname ?? "",
            "university": UserData.loggedInUser?.institution ?? "",
            "referBy": referBy
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
                        completion(true, "Saved Successfully!")
                    }
                }
            }
        }
    }
    
    
  //  &fullname=test&email=abc@gmail.com&referBy=stunii&university=xyz
    
    class func getAllProviders(param:String,completion: @escaping completionClosure<[Provider]>) {
        let url = WebServicesURL.baseURL + WebServicesURL.providers + param
        print(url)
        APIManager.shared.getAPI(url: url) { (response, error) in
            if let data = response as? [String: Any],
                let dataArray = data["data"] as? [[String: Any]]{
                print(data)
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
        print(url,id)
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
        print(request)
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
        let url = WebServicesURL.baseURL + WebServicesURL.dealDetail+id+"&lat=\("\(locValue==nil ? 0.0:locValue.latitude)")&lng=\("\(locValue==nil ? 0.0:locValue.longitude)")"
        print(url)
//        let param = "lat=\("\(locValue==nil ? 0.0:locValue.latitude)")&lng=\("\(locValue==nil ? 0.0:locValue.longitude)")"
        
        APIManager.shared.getAPI(url: url) { (response, error) in
            if let data = response as? [String: Any],
    
                let dataObject = data["data"] as? [String: Any] {
                 print(data)
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
   
    
  class func getReferral(completion: @escaping completionClosure<[Referral]>) {
         let url = WebServicesURL.baseURL + WebServicesURL.getReferral
         APIManager.shared.getAPI(url: url) { (response, error) in
             if let data = response as? [String: Any],
                 let dataArray = data["from"] as? [[String: Any]]{
                 let referal = Mapper<Referral>().mapArray(JSONArray: dataArray)
                 completion(referal, nil)
             }
             else {
                 completion(nil, error)
             }
         }
     }
       
    
    class func forgotPassword(email: String,
                              completion: @escaping ((Bool, String?)->())) {
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.forgotPassword)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "email": email
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let __ = response as? HTTPURLResponse {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let _json = json as? [String: Any] {
                        if let status = _json["success"] as? Int {
                            if status == 0 {
                                completion(false, _json["message"] as? String)
                            }
                        }
                        else if let _ = _json["token"] {
                            completion(true, "Password reset successfully.")
                        }
                    }
                }
                catch {
                   completion(false, error.localizedDescription)
                }
            }else{
               completion(false, error?.localizedDescription)
            }
        }
        mData.resume()
    }
    
    class func validateEmail(email: String,
                                completion: @escaping ((Bool, String?)->())) {
          let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.validateEmail)
          let request = NSMutableURLRequest(url: url! as URL)
//          request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
          request.httpMethod = "POST"
          request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          
          let parameters: [String: Any] = [
              "email": email
          ]
          do {
              request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
          } catch let error {
              print(error.localizedDescription)
          }
          
          let session = URLSession.shared
          
          let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
              if let __ = response as? HTTPURLResponse {
                  do {
                      let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(json)
                      DispatchQueue.main.async {
                      if let _json = json as? [String: Any] {
                          if let status = _json["success"] as? Int {
                              if status == 0 {
                                  completion(false, _json["message"] as? String)
                              }else{
                               completion(true, _json["message"] as? String)
                            }
                          }
                          
                      }
                    }
                  }
                  catch {
                     completion(false, error.localizedDescription)
                  }
              }else{
                 completion(false, error?.localizedDescription)
              }
          }
          mData.resume()
      }
    
    class func login(email: String, password: String, completion: @escaping completionClosure<User>) {
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.signin)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         let fcmToken =   UserDefaults.standard.string(forKey: UserDefaultKey.deviceToken) ?? ""
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "device_token":fcmToken
        ]
        print("************->",parameters)
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
    
    
    class func sendStripeToken(_ token: String,planId:String,couponId:String,offerId:String,
                               completion: @escaping (Bool, String?)->(())) {
     //   let url = "http://108.61.175.63:40117/api/vipTestsub?" //WebServicesURL.baseURL + WebServicesURL.stripeToken
        let url = "https://api.stunii.com/vipSub?" //WebServicesURL.baseURL + WebServicesURL.stripeToken

        let params: [String: String] = [
            "emailuser": UserData.loggedInUser?.email ?? "",
            "userid": UserData.loggedInUser?._id ?? "",
            "name": UserData.loggedInUser?.fname ?? "",
            "mobile": UserData.loggedInUser?.phone_number ?? "",
            "lastname": UserData.loggedInUser?.lname ?? "",
            "type": "I",
            "stripetoken": token,
            "planid":planId,
            "couponid":couponId,
            "offerid":offerId
        ]
        print(params)
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
    
    class func applyPromoCode(_ coupenCode: String,
                                  completion: @escaping completionClosure<[String:Any]>) {
        
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.applyPromoCode)
               let request = NSMutableURLRequest(url: url! as URL)
               request.httpMethod = "POST"
               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               
               let parameters: [String: String] = [
                   "user_id": UserData.loggedInUser?._id ?? "",
                   "coupan_code":coupenCode
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
    
    class func getPremiumOffers(completion: @escaping ((Any?, Error?)->())) {
        let url = WebServicesURL.baseURL + WebServicesURL.premiumOffers+"lat=\("\(locValue==nil ? 0.0:locValue.latitude)")&lng=\("\(locValue==nil ? 0.0:locValue.longitude)")"
        APIManager.shared.getAPI(url: url) { (response, error) in
            if let err = error {
                completion(nil, err)
            }
            else if let json = response as? [String: Any] {
                print(json)
                var result: ([Deal]?, String?,[Plan]?) = (nil, nil,nil)
                if let dealsArray = json["premium"] as? [[String: Any]] {
                    let deals = Mapper<Deal>().mapArray(JSONArray: dealsArray)
                    result.0 = deals
                }
                if let planArray = json["plan"] as? [[String: Any]] {
                    let plans = Mapper<Plan>().mapArray(JSONArray: planArray)
                    result.2 = plans
                }
                if let price = json["dynamic_texts"] as? String {
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
                        let createAt = _json["created_at"] as? String{
                        print(_json)
                        var stuId = StuId(date: createAt, graduationDate: _json["graduationDate"] as? String ?? "",dob:_json["dob"] as? String ?? "")
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
    
    
    class func redeamDealPayment(id:String,completion: @escaping (Bool?)->()) {
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.redeamPayment+id)
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
                    if let _json = json as? [String: Any]{
                        print(_json)
                        completion(true)
                    }
                }
                catch {
                    completion(false)
                }
            }else{
                completion(false)
            }
        }
        mData.resume()
    }
    
    
    func getCategoryDetail(id:String, completion: @escaping completionClosure<[String: Any]>) {
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.categoryDetail+id+"&lat=\("\(locValue==nil ? 0.0:locValue.latitude)")&lng=\("\(locValue==nil ? 0.0:locValue.longitude)")")
      
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        let parameters: [String: Any] = [
//            "categoryId": id
//        ]
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//        } catch let error {
//            print(error.localizedDescription)
//        }
        
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
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.subCategoryDetail+id+"&lat=\("\(locValue==nil ? 0.0:locValue.latitude)")&lng=\("\(locValue==nil ? 0.0:locValue.longitude)")")
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
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
    
    func getNearMeDeals(completion: @escaping completionClosure<[Deal]>){
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.nearMeDeals+"&lat=\("\(locValue==nil ? 0.0:locValue.latitude)")&lon=\("\(locValue==nil ? 0.0:locValue.longitude)")")
        print(url)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        
        let session = URLSession.shared
        
        let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            var _error: String?
            
            var deals:[Deal] = []
            if let res = response as? HTTPURLResponse {
                do {
                    guard let dat = data as? Data else{
                        return
                    }
                    let json = try JSONSerialization.jsonObject(with: dat,options: .allowFragments)
                    print(json)
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
        let url = NSURL(string: WebServicesURL.baseURL + WebServicesURL.providerDetail+id+"&lat=\("\(locValue==nil ? 0.0:locValue.latitude)")&lng=\("\(locValue==nil ? 0.0:locValue.longitude)")")
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("YW5kcm9pZF9hcHA6MzA1MEI3V1QwVmoz", forHTTPHeaderField: "Authorization") //**
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        let parameters: [String: Any] = [
//            "providerId": id
//        ]
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//        } catch let error {
//            print(error.localizedDescription)
//        }
        
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
