//
//  HomeData.swift
//  Stunii
//
//  Created by Zap.Danish on 15/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeData: Mappable {
    
    var id      : String?
    var name    : String?
    var image   : String?
    var deals   : [Deal] = []
    
    var isFeatured: Bool {
        return ((name ?? "") == "Featured")
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id      <- map["_id"]
        name    <- map["name"]
        image   <- map["photo"]
        deals   <- map["data"]
    }
}
