//
//  User.swift
//  Stunii
//
//  Created by inderjeet on 02/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import ObjectMapper
class User: Mappable, Codable {
    var _id: String!
    var email: String?
    var fname: String?
    var lname: String?
    var photoUrl: String?
    var type: String?
    var access_token: String?
    var device_token: String?
    var institution: String?
    var personal_email: String?
   var  phone_number: String?
    var isVIP: Bool?
    
   // init( _id: String!, email: String?, fname: String?, lname: String?, photoUrl: String?, type: String?, access_token: String?, device_token: String?, institution: String?, personal_email: String?
//        , phone_number: String?, isVIP: Bool?) {
//        super.init()
//         self._id = _id
//         self.email = email
//         self.fname = fname
//         self.lname = lname
//         self.photoUrl = photoUrl
//         self.type = type
//         self.access_token = access_token
//         self.device_token = device_token
//         self.institution = institution
//         self.personal_email = personal_email
//          self.phone_number = phone_number
//         self.isVIP = isVIP
//
//
//    }
    
     required init?(map: Map) {}
    func mapping(map: Map) {
         _id <- map["_id"]
         email <- map["email"]
         fname <- map["fname"]
         lname <- map["lname"]
         photoUrl <- map["photo"]
         type <- map["type"]
         access_token <- map["access_token"]
         device_token <- map["device_token"]
         institution <- map["institution"]
         personal_email <- map["personal_email"]
          phone_number <- map["phone_number"]
         isVIP <- map["isVIP"]
    }
//    override init() {
//        super.init()
//    }
//    required convenience init(coder aDecoder: NSCoder) {
//        _id = aDecoder.decodeObject(forKey: "id") as? String
//        email = aDecoder.decodeObject(forKey: "email") as? String
//        fname = aDecoder.decodeObject(forKey: "fname") as? String
//        lname = aDecoder.decodeObject(forKey: "lname") as? String
//        photoUrl = aDecoder.decodeObject(forKey: "photoUrl") as? String
//        type = aDecoder.decodeObject(forKey: "type") as? String
//        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
//        device_token = aDecoder.decodeObject(forKey: "device_token") as? String
//        institution = aDecoder.decodeObject(forKey: "institution") as? String
//        personal_email = aDecoder.decodeObject(forKey: "personal_email") as? String
//        phone_number = aDecoder.decodeObject(forKey: "phone_number") as? String
//        isVIP = aDecoder.decodeBool(forKey: "isVIP")
//
//        self.init(_id:_id, email:email, fname:fname, lname:lname, photoUrl:photoUrl, type:type, access_token:access_token, device_token:device_token, institution:institution, personal_email:personal_email,  phone_number: phone_number, isVIP: isVIP
//        )
//    }
//
//    func encode(with aCoder: NSCoder) {
//         aCoder.encode(_id, forKey: "id")
//         aCoder.encode(email, forKey: "email")
//         aCoder.encode(fname, forKey: "fname")
//         aCoder.encode(lname, forKey: "lname")
//         aCoder.encode(photoUrl, forKey: "photoUrl")
//         aCoder.encode(type, forKey: "type")
//         aCoder.encode(access_token, forKey: "access_token")
//         aCoder.encode(device_token, forKey: "device_token")
//         aCoder.encode(institution, forKey: "institution")
//         aCoder.encode(personal_email, forKey: "personal_email")
//         aCoder.encode(phone_number, forKey: "phone_number")
//         aCoder.encode(isVIP, forKey: "isVIP")
//    }
//
//
    class func get() -> User? {
         let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(User.self, from: savedPerson) {
               return loadedPerson
            }
        }
//        if let decoded  =  UserDefaults.standard.data(forKey: "user") {
//        let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? User
//        }
        return nil
    }
    
    class func save(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "user")
        }
//        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
//         UserDefaults.standard.set(encodedData, forKey: "user")
         UserDefaults.standard.synchronize()
    }
    
}
