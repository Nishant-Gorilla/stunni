//
//  SignupUIModel.swift
//  Stunii
//
//  Created by Zap.Danish on 29/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

struct SignUpUIModel {
    
    private(set) var titles             : [String] = []
    private(set) var optionsHeading     : String = ""
    private(set) var images             : [UIImage] = []
    private(set) var bgImage            : UIImage!
    private(set) var scratchImage       : UIImage!
    private(set) var progressImage      : UIImage!
    private(set) var keyboardType       : [UIKeyboardType]!
    private(set) var selectedOption      : Int!
    
    func get() -> [SignUpUIModel] {
        return populateData()
    }
    
    private func populateData() -> [SignUpUIModel] {
        let array: [SignUpUIModel] = [
            SignUpUIModel(
                titles: ["First Name", "Last Name", "DOB"],
                optionsHeading: "",
                images: [],
                bgImage: #imageLiteral(resourceName: "screen1-bg"),
                scratchImage: #imageLiteral(resourceName: "cracking"),
                progressImage: #imageLiteral(resourceName: "progress1"),
                keyboardType: [.default, .default, .numberPad],
                selectedOption: nil
            ),
            SignUpUIModel(
                titles: ["Educational Email Address", "Personal Email Address", "Phone Number"],
                optionsHeading: "",
                images: [],
                bgImage: #imageLiteral(resourceName: "screen2-bg"),
                scratchImage: #imageLiteral(resourceName: "cracking"),
                progressImage: #imageLiteral(resourceName: "progress2"),
                keyboardType: [.emailAddress, .emailAddress, .phonePad],
                selectedOption: nil
            ),
            SignUpUIModel(
                titles: ["Educational Institute", "Course", "Graduation Date"],
                optionsHeading: "",
                images: [],
                bgImage: #imageLiteral(resourceName: "screen3-bg"),
                scratchImage: #imageLiteral(resourceName: "cracking"),
                progressImage: #imageLiteral(resourceName: "progress3"),
                keyboardType: [.default, .default, .numberPad],
                selectedOption: nil
            ),
            
            SignUpUIModel(titles: [],
                          optionsHeading: "",
                          images: [],
                          bgImage: #imageLiteral(resourceName: "bg-password"),
                          scratchImage: #imageLiteral(resourceName: "create-password"),
                          progressImage: #imageLiteral(resourceName: "progress4"),
                          keyboardType: [],
                          selectedOption: nil
            ),
            
            SignUpUIModel(
                titles: ["Male", "Female", "Other", ""],
                optionsHeading: "Gender",
                images: [#imageLiteral(resourceName: "male"), #imageLiteral(resourceName: "female"), #imageLiteral(resourceName: "other"), #imageLiteral(resourceName: "direction")],
                bgImage: #imageLiteral(resourceName: "screen4-bg"),
                scratchImage: #imageLiteral(resourceName: "nearly-there"),
                progressImage: #imageLiteral(resourceName: "progress5"),
                keyboardType: [],
                selectedOption: nil
                
            ),
            SignUpUIModel(
                titles: ["Vegan", "Veggie", "Meat Eater", ""],
                optionsHeading: "Are You?",
                images: [#imageLiteral(resourceName: "vegan"), #imageLiteral(resourceName: "veggie"), #imageLiteral(resourceName: "meat-eater"), #imageLiteral(resourceName: "home_g")],
                bgImage: #imageLiteral(resourceName: "screen5-bg"),
                scratchImage: #imageLiteral(resourceName: "nearly-there"),
                progressImage: #imageLiteral(resourceName: "progress6"),
                keyboardType: [],
                selectedOption: nil
                
            ),
            SignUpUIModel(
                titles: ["Nightlife", "Pub", "Meal", "Cozy"],
                optionsHeading: "Perfect Night Out",
                images: [#imageLiteral(resourceName: "nightclub"), #imageLiteral(resourceName: "pub"), #imageLiteral(resourceName: "meal"), #imageLiteral(resourceName: "cozy")],
                bgImage: #imageLiteral(resourceName: "screen6-bg"),
                scratchImage: #imageLiteral(resourceName: "nearly-there"),
                progressImage: #imageLiteral(resourceName: "progress7"),
                keyboardType: [],
                selectedOption: nil
            ),
            SignUpUIModel(
                titles: ["At Gym", "At Library", "Gaming", "Outdoors"],
                optionsHeading: "You're most likely to find me:",
                images: [#imageLiteral(resourceName: "gym"), #imageLiteral(resourceName: "library"), #imageLiteral(resourceName: "gaming"), #imageLiteral(resourceName: "outdoors")],
                bgImage: #imageLiteral(resourceName: "screen7-bg"),
                scratchImage: #imageLiteral(resourceName: "last-step"),
                progressImage: #imageLiteral(resourceName: "progress8"),
                keyboardType: [],
                selectedOption: nil
            )
        ]
        return array
    }
    
    static func validate(value:String?, key: String) -> String? {
        var error: String?
        switch key {
        case "firstName", "lastName":
            let type = key == "firstName" ? "first name" : "last name"
            error = FormValidator.checkValidName(value, type: type)
        case "dob":
            error = FormValidator.checkValidDOB(value)
        case "phone":
            error = FormValidator.checkValidPhone(value)
        case "eduEmail", "personalEmail":
            error = FormValidator.checkValidEmail(key: key,value)
        case "institute":
             error = FormValidator.checkValidInstitute(value)
        case "course":
            error = FormValidator.checkValidCourse(value)
        case "graduationDate":
            error = FormValidator.checkValidGraduationYear(value)
        case "password":
            error = FormValidator.checkValidPassword(value)
        case  "subscription": break
        case "gender": break
        case "vegan": break
        case "nightOut",  "hobby": break
        default:
            break
        }
        return error
    }
    
    static func signUp(fields: SignUpFields, completion:@escaping (String?)->()) {
        var gender = 0
        var string = (fields.gender ?? "").replacingOccurrences(of: " ", with: "").lowercased()
        switch string {
        case "male":
            gender = 1
        case "female":
            gender = 2
        case "other":
            gender = 3
        default:
            break
        }
        var areYou = 0
        string = (fields.vegan ?? "").replacingOccurrences(of: " ", with: "").lowercased()
        switch string {
        case "vegan":
            areYou = 1
        case "veggie":
            areYou = 2
        case "meateater":
            areYou = 3
        default:
            break
        }
        
        var perfectNightOut = 0
        string = (fields.nightOut ?? "").replacingOccurrences(of: " ", with: "").lowercased()
        switch string {
        case "nightlife":
            perfectNightOut = 1
        case "pub":
            perfectNightOut = 2
        case "meal":
            perfectNightOut = 3
        case "cozy":
            perfectNightOut = 4
        default:
            break
        }
        
        var findMe = 0
        
        string = (fields.hobby ?? "").replacingOccurrences(of: " ", with: "").lowercased()
        switch string {
        case "atgym":
            findMe = 1
        case "atlibrary":
            findMe = 2
        case "gaming":
            findMe = 3
        case "outdoors":
            findMe = 4
        default:
            break
        }
        let fcmToken =   UserDefaults.standard.string(forKey: UserDefaultKey.deviceToken) ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.date(from: fields.dob!)!
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateStr = dateFormatter.string(from: date)
        let param: [String:Any] = [
            "lname": fields.lastName ?? "",
            "fname": fields.firstName ?? "",
            "email": fields.eduEmail ?? "",
            "personal_email": fields.personalEmail ?? "",
            "password": fields.password ?? "",
            "institution": fields.institute ?? "",
            "graduationDate":fields.graduationDate ?? "",
            "emailNotification": fields.subscription ?? "0",
            "areYou": String(areYou),
            "findMe":String(findMe),
            "perfectNightOut":String(perfectNightOut),
            "gender":String(gender),
            "type":"student",
            "dob":dateStr,
            "phone_number": fields.phone ?? "",
            "course": fields.course ?? "",
            "device_token": fcmToken
        ]
        
        APIHelper().signUp(parameters: param) { (user, error) in
            if error == nil && user != nil {
                UserData.loggedInUser = user!
                MainScreenUtility.setHomeAsRoot()
                completion(nil)
            } else {
                completion(error?.localizedDescription ?? "Signup failed!")
            }
        }
    }
}
