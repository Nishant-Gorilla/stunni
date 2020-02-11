//
//  Referral.swift
//  Stunii
//
//  Created by Ajay Kumar on 20/10/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import  ObjectMapper
class Referral : Mappable {
    var id: String?
    var referralfrom: String?
    var updatedAt: String?
    var createdAt: String?
    required init?(map: Map) {}
    //Mapping
    func mapping(map: Map) {
        id <- map["_id"]
        referralfrom <- map["referral_from"]
        updatedAt <- map["updated_at"]
        createdAt <- map["created_at"]
       
    }
}
