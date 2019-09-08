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
    
    func getAPI(url: String, parameters:[String: String]? = nil, completion: @escaping completionClosure) {
        var urlComponent = URLComponents(string: url)
        if let parameters = parameters {
            var queryItems: [URLQueryItem] = []
            let keys = parameters.keys
            keys.forEach { (key) in
                let value = parameters[key]
                queryItems.append(URLQueryItem(name: key, value: value ?? ""))
            }
            urlComponent?.queryItems = queryItems
        }
        
        Alamofire.request(urlComponent!.url!).responseJSON { (response) in
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
    
    func multipart(image: UIImage, completion: @escaping ((Bool?)->())) {
        let imgData = image.jpegData(compressionQuality: 0.40)
        
//        let parameters = ["studentId": UserData.loggedInUser!._id] //Optional for extra parameter
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData!, withName: "photo",fileName: "file.jpg", mimeType: "image/jpg")
//            for (key, value) in parameters {
//                multipartFormData.append(value!.data(using: String.Encoding.utf8)!,
//                                         withName: key)
//            } //Optional for extra parameters
        },
                         to: WebServicesURL.baseURL+WebServicesURL.uploadImage)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if let json = response.result.value as? [String: Any] {
                        if let status = json["status"] as? Int {
                            if status == 200 {
                                completion(true)
                                return
                            }
                        }
                    }
                    completion(false)
                }
                
            case .failure(let encodingError):
                print(encodingError)
                completion(false)
            }
        }
    }
}


//MARK:- APIClient
class APIClient {
    
    func initialize() {
        APIManager.shared.setHeader(value: "Content-Type", forKey: "application/json")
    }
    
}
