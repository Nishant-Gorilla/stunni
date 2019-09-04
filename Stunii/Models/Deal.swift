//
//  Deal.swift
//  Stunii
//
//  Created by Zap.Danish on 15/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import ObjectMapper

class Deal: Mappable {
    
    var id          : String?
    var title       : String?
    var desc        : String?
    var location    : String?
    var address     : String?
    var ratings     : String?
    var photo       : String?
    var coverPhoto  : String?
    var isVIP       : String?
    var legal       : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        
        id      <- map["_id"]
        title   <- map["title"]
        desc    <- map["desc"]
        photo <- map["photo"]
        coverPhoto <- map["coverPhoto"]
        photo = WebServicesURL.ImagesBase.home + id! + "/o/" + (photo ?? "")
        coverPhoto  = WebServicesURL.ImagesBase.home + id! + "/o/" + (coverPhoto ?? "")
    }
}
