//
//  Plan.swift
//  Stunii
//
//  Created by Ajay Kumar on 19/01/20.
//  Copyright © 2020 Gorilla App Development. All rights reserved.
//

import UIKit
import ObjectMapper

class Plan: Mappable {
    var id          : String?
    var description : String?
    var plan_id     : String?
    var price       :String?
    
    
    required init?(map: Map) {}
      
      func mapping(map: Map) {
           id <- map[ "_id"]
          description <- map["description"]
          plan_id <- map["plan_id"]
          price <- map["price"]
    }
}
