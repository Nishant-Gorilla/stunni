//
//  FormValidator.swift
//  Stunii
//
//  Created by inderjeet on 01/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
class FormValidator {
    
    class func checkValidEmail(key:String?,_ email:String?) -> String? {
        guard let email = email, !email.trimSpace().isEmpty else {
            return "Please enter email address "
        }
        var error: String?
        let emailTest = NSPredicate(format:"SELF MATCHES %@", Regx.email)
        if !emailTest.evaluate(with: email){
            error = ValidationMessage.email.invalid
        }
        if key == "eduEmail"{
            if email.range(of: "ac.uk") == nil{
                error = "Please enter a valid educational email."
            }
        }
        return error
    }
    
    class func checkValidPassword(_ password: String?) -> String? {
        guard let password = password, !password.trimSpace().isEmpty else {
            return "Please enter password"
        }
        if password.count > InputLengthConstraints.Maximum.password {
            return ValidationMessage.password.tooLong
        } else if password.count < InputLengthConstraints.Minimum.password {
        return ValidationMessage.password.tooShort
        }
        return nil
    }
    
    class func checkValidName(_ name: String?, type:String) -> String? {
        guard let name = name, !name.trimSpace().isEmpty else {
            return "Please enter \(type)"
        }
        // Check name length
        if name.trimSpace().count > InputLengthConstraints.Maximum.name {
            return ValidationMessage.name.tooLong
        }
    return nil
}
    
    class func checkValidPhone(_ phone: String?) -> String? {
        guard let phone = phone, !phone.trimSpace().isEmpty else {
            return "Please enter mobile number"
        }
        var error: String?
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", Regx.phone)
        if !phoneTest.evaluate(with: phone) {
            error = ValidationMessage.phone.invalid
        }
        return error
    }
    
    class func checkValidDOB(_ dob: String?) -> String? {
        guard let dob = dob , !dob.trimSpace().isEmpty else {
            return "Please select DOB"
        }
        return nil
    }
    class func checkValidInstitute(_ institute: String?) -> String? {
        if isEmpty(institute) {
            return "Please select educational institute"
        }
        return nil
    }
    
    class func checkValidCourse(_ course: String?) -> String? {
        if isEmpty(course) {
            return "Please enter course"
        }
        return nil
    }
    class func checkValidGraduationYear(_ year: String?) -> String? {
        if isEmpty(year) {
             return "Please select graduation date"
        }
        return nil
    }
    
    private class func isEmpty(_ value: String?) -> Bool {
        guard let value  = value , !value.trimSpace().isEmpty else {
            return true
        }
        return false
    }
    
}
