//
//  Address.swift
//  Stunii
//
//  Created by inderjeet on 30/08/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import ObjectMapper
class Address: Mappable {
    var street: String?
    var city: String?
    var zip: String?
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        street <- map["street"]
        city <- map["city"]
        zip <- map["zip"]
    }
    
}
