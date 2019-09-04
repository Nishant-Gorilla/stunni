//
//  User.swift
//  Stunii
//
//  Created by inderjeet on 02/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import ObjectMapper
class User: Mappable {
    var _id: String!
    var email: String?
    var fname: String?
    var lname: String?
    var photoUrl: String?
    var type: String?
    var access_token: String?
    var device_token: String?
    var institution: String?
    var personal_email: String?
   var  phone_number: String?
    var isVIP: Bool?
    
     required init?(map: Map) {}
    func mapping(map: Map) {
         _id <- map["_id"]
         email <- map["email"]
         fname <- map["fname"]
         lname <- map["lname"]
         photoUrl <- map["photo"]
         type <- map["type"]
         access_token <- map["access_token"]
         device_token <- map["device_token"]
         institution <- map["institution"]
         personal_email <- map["personal_email"]
          phone_number <- map["phone_number"]
         isVIP <- map["isVIP"]
    }
    
}
