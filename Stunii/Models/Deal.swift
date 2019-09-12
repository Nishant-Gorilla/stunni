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
    var provider: Provider?
    var providers: [Provider] = []
    var id          : String?
    var title       : String?
    var desc        : String?
    var address     : Address?
    var photo       : String?
    var coverPhoto  : String?
    var accommodation_email: String?
    var scanForRedeem: Bool?
    var hot:[Bool] = []
    var location: Location?
    var web: String?
    var facebook: String?
    var instagram: String?
     var affiliate: String?
    var distance: Float?
    var isLiked: Bool?
    var slug: String?
    var meta_title: String?
    var meta_description: String?
    var views: Int?
    var ratings : Float?
    var isActive: Bool?
    var isEvent : Bool?
    var limitByStudent: Int?
    var redeemType: String?
    var limitTotal: Int?
    var price_original: Float?
    var price: Float?
    var code: String?
    var sortnum: Int?
    var featured: Bool?
    var isVIP: Bool?
    var type_city: String?
    var type: Int?
    var legal: String?
    var similarDeals:[Deal] = []
    var metaTtitle: String?
    var metaDescription: String?
    var startDay: String?
    var endDay: String?
    
    

    required init?(map: Map) {}
    
    func mapping(map: Map) {
         id <- map[ "_id"]
    
         provider <- map["_provider"]
        if provider == nil {
            providers <- map["_provider"]
            provider = providers.first
        }
        title  <- map["title"]
        desc  <- map["desc"]
        location <- map["location"]
        address  <- map["address"]
        accommodation_email <- map["accommodation_email "]
        scanForRedeem <- map["scanForRedeem"]
        hot <- map["hot"]
        web <- map["web"]
        facebook <- map["facebook"]
        instagram <- map["instagram"]
        affiliate <- map["affiliate"]
        distance <- map["distance"]
        isLiked <- map["isLiked"]
        slug <- map["slug"]
        meta_title <- map["meta_title"]
        metaDescription <- map["meta_description"]
        views <- map["views"]
        ratings <- map["ratings"]
        isActive <- map["isActive"]
        isEvent <- map["isEvent"]
        limitByStudent <- map["limitByStudent"]
        redeemType <- map["redeemType"]
        limitTotal <- map["limitTotal"]
        price_original <- map["price_original"]
        price <- map["price"]
        code <- map["code"]
        coverPhoto <- map["coverPhoto"]
        photo <- map["photo"]
        sortnum <- map["sortnum"]
        featured <- map["featured"]
        isVIP <- map["isVIP"]
        type_city <- map["type_city"]
        type <- map["type"]
        legal <- map["legal"]
        similarDeals <- map["category"]
        startDay <- map["startDay"]
        endDay <- map["endDay"]
        photo = WebServicesURL.ImagesBase.home + id! + "/o/" + (photo ?? "")
        coverPhoto  = WebServicesURL.ImagesBase.home + id! + "/o/" + (coverPhoto ?? "")
    }
}
