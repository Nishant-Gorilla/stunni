//
//  Location.swift
//  Stunii
//
//  Created by inderjeet on 30/08/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import ObjectMapper
class Location: Mappable {
    var latitude: Double?
    var longitude: Double?
    var radious: Double?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        latitude <- map["lat"]
        longitude <- map["lng"]
        radious <- map["r"]
    }
    
}
