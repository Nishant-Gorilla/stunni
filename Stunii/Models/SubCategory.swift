//
//  SubCategory.swift
//  Stunii
//
//  Created by inderjeet on 08/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import ObjectMapper
class SubCategory: Mappable {
    var id: String?
    var categoryId: String?
    var subCategoryName: String?
    var __v: Int?
    
    
    required init?(map: Map) {}
    //Mapping
    func mapping(map: Map) {
        id <- map["_id"]
        categoryId <- map["categoryId"]
        subCategoryName <- map["subCategoryName"]
        __v <- map["__v"]
    }
}
