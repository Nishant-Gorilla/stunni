//
//  Provider.swift
//  Stunii
//
//  Created by inderjeet on 30/08/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import ObjectMapper
class Provider: Mappable {
    var id: String?
    var updated_at: String?
    var created_at: String?
    var name: String?
    var address: Address?
    var location: Location?
    var person: String?
    var email: String?
    var password: String?
    var desc: String?
    var phones: [String] = []
    var coverPhotoURL: String?
    var photoURL: String?
    
    required init?(map: Map) {}
    
    func mapping(map:Map) {
         id  <- map["_id"]
         updated_at  <- map["updated_at"]
         created_at  <- map["created_at"]
        name  <- map["name"]
        address  <- map["address"]
        location   <- map["location"]
        person  <- map["person"]
        email  <- map["email"]
        password  <- map["password"]
        desc  <- map["desc"]
        phones  <- map["phones"]
        coverPhotoURL  <- map["coverPhoto"]
        photoURL  <- map["photoURL"]
    }
    
}
