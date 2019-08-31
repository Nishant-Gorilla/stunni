//
//  Category.swift
//  Stunii
//
//  Created by inderjeet on 29/08/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import  ObjectMapper
class Category : Mappable {
    var id: String?
    var name: String?
    var photoURL: String?
    var updatedAt: String?
    var createdAt: String?
    
    required init?(map: Map) {}
    //Mapping
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        photoURL <- map["photo"]
        updatedAt <- map["updated_at"]
        createdAt <- map["created_at"]
        photoURL = WebServicesURL.ImagesBase.category + (id ?? "") + "/o/" + (photoURL ?? "")
    }
}
