//
//  Constants.swift
//  Stunii
//
//  Created by Uday Bhateja on 23/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

let POUNDS_STRING = "£"

//MARK:- API URLs
struct WebServicesURL {
    static let baseURL : String = "https://api.stunii.com/"
    
    static let signup  : String = "students/signup"
    static let signin  : String = "students/signin"
    static let home    : String = "home/hero"
    static let category: String = "categories"
    static let providers = "allProvider"
    static let jobs = "allJobs"
    static let jobDetail = "jobDetail"
    static let dealDetail = "dealDetail"
    static let isVipUser = "isVip"
    static let stripeToken = "vipsubscription"
    static let premiumOffers = "premiumOffers"
    static let checkQr = "checkQr"
    static let countDealLimit = "countDealLimit"
    static let redeemDeal = "redeemed"
    static let stuId = "students/" + (UserData.loggedInUser?._id)!
    static let uploadImage = "studentSqid?studentId=" + (UserData.loggedInUser?._id)!
    static let categoryDetail = "categoryDetail"
    static let subCategoryDetail = "subcategoryDetail"
    static let providerDetail = "providerDetail"
    static let demandDeal = "demandDeal"
    
    struct ImagesBase {
        static let home : String = baseURL + "fs/deals/"
        static let category: String = baseURL + "fs/categories/"
        static let gallary: String = baseURL + "fs/galleries/"
        static let provider: String = baseURL + "fs/providers/"
        static let students: String = baseURL + "fs/students/"
        static let jobs: String = baseURL + "images/"
    }
}

class UserData {
    static var loggedInUser: User? 
}

//MARK:- Storyboard ID
struct Storyboard {
    struct Name {
        static let main         : String = "Main"
        static let onboarding   : String = "Onboarding"
        static let signup       : String = "Auth"
        static let deals        : String = "Deals"
    }
    struct Identifier {
        static let deal : String = "DealsVC"
    }
}


//MARK:- Reges
struct Regx {
    static let email = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z]{2,})$"
    static let name = "\\w{7,18}"
    static let phone = "[0-9]{11}$"
}

struct InputLengthConstraints {
    struct Minimum {
        static let password = 6
        static let phoneNumber = 10
        static let name = 1
    }
    struct Maximum {
        static let userName = 100
        static let password = 20
        static let email = 50
        static let phoneNumber = 10
        static let name = 50
        static let year = 4
        static let broadcastTitle = 100
        static let description = 250
    }
}


struct ValidationMessage{
    struct name {
        static let tooLong = "Name cannot be more than \(InputLengthConstraints.Maximum.name) characters"
        static let empty = "Please enter the name"
        static let numeric = "Name cannot have numeric values"
        static let specialCharacters = "Name cannot have special characters"
        static let tooSmall = "Name cannot be more than \(InputLengthConstraints.Maximum.name) characters"
        
    }
    struct phone {
        static let invalid = "Please enter a valid mobile number"
    }
    struct email {
        static let empy = "Please enter the email address"
        static let invalid = "Please enter a valid email address"
        static let exists = "The email address already exists"
    }
    
    struct password {
        static let confirm = "Please confirm your password"
        static let tooShort = "Password cannot be less than 6 characters"
        static let tooLong = "Password cannot be more than 20 characters"
        
    }
    
    
    static let selectSport = "Please select sports first"
    static let noInternetConnection = "Check your internet connection"
    static let userName = "Please enter Username"
    static let enterName = "Please enter Name"
    static let enterValidName = "Please enter valid Name"
    static let enterScreenName = "Please enter Screen "
    static let instalationDate = "Please enter instalation date"
    static let enterPhoneMinimumLength = "Phone should be atleast 10 digits"
    static let enterAddress = "Please enter address"
    static let enterFullName = "Please enter Full Name"
    static let firstNameMinimumLength = "First name should be atleast 3 characters"
    static let enterEmail = "Please enter email address"
    static let enterValidEmail = "Please enter valid email address"
    static let enterUserName = "Please enter Username"
    static let enterCurrentPassword = "Please enter current password"
    static let enterNewPassword = "Please enter new password"
    static let enterMessage = "Please enter message"
    static let enterConfirmPassword = "Please enter confirm password"
    
    static let selectCategory = "Please select category"
    static let selectUser = "Please select user"
    static let selectAdvertisment = "Please select advertisment"
    static let selectScreen = "Please select screen"
    static let enterStartDate = "Please select startdate"
    static let endDate = "Please select endDate"
    static let updateAlertMessage = "New version is available. Please update application"
    static let fillEmptyFields = "Please fill empty fields"
    static let fillListName = "Please fill list name"
    
}


//MARK:- Stunii Font
struct StuniiFont {
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Regular", size: size)!
    }
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "ProximaNova-Bold", size: size)!
    }
}

//MARK:- StuniiColor
struct StuniiColor {
    static let orange = UIColor(hex: 0xCD492D)
}

//MARK:- Collection View Cells
struct CVCell {
    struct Identifier {
        static let home = "cell_home"
        static let deal = "cell_deals"
    }
    
    struct Name {
        static let home = "HomeCollectionViewCell"
        static let deals = "DealsCollectionViewCell"
    }
}

//MARK:- UserDefault Constants
struct UserDefaultKey {
    static let deviceToken = "deviceToken"
}

struct APIKeys {
    static let stripe = "pk_test_Qhkxp3lPza9CaAkvLKYh4WpM"
}
