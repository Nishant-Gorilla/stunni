//
//  ReferralModel.swift
//  Stunii
//
//  Created by Ajay Kumar on 19/01/20.
//  Copyright © 2020 Gorilla App Development. All rights reserved.
//
import Foundation
import  ObjectMapper

class PromoModel : Mappable {
    var id: String?
    var description: Int?
    var coupanId :String?
    required init?(map: Map) {}
    //Mapping
    func mapping(map: Map) {
        id <- map["_id"]
        description <- map["description"]
        coupanId <- map["coupan_id"]
       
    }
}
