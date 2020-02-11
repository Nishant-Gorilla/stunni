//
//  Job.swift
//  Stunii
//
//  Created by inderjeet on 04/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//
import ObjectMapper
import Foundation
class Job: Mappable {
    var id: String?
    var jobName: String?
    var jobAddress: String?
    var jobType: String?
    var jobDescription: String?
    var companyName: String?
    var jobRate: String?
    var companyImage: String?
    var companyEmail: String?
    var v:Int?
 
    
    required init?(map: Map) {}
    func mapping(map: Map) {
        id <- map["_id"]
        jobName <- map["jobName"]
        jobAddress <- map["jobAddress"]
        jobType <- map["jobType"]
        jobDescription <- map["jobDescription"]
        companyName <- map["companyName"]
        jobRate <- map["jobRate"]
        companyImage <- map["companyImage"]
        v <- map["__v"]
        companyEmail <- map["companyEmail"]
        companyImage = WebServicesURL.ImagesBase.jobs + (companyImage ?? "")
        
    }
    
}


