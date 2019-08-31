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
    
    struct ImagesBase {
        static let home : String = baseURL + "fs/deals/"
        static let category: String = baseURL + "fs/categories/"
        static let gallary: String = baseURL + "fs/galleries/"
        static let provider: String = baseURL + "fs/providers/"
        static let students: String = baseURL + "fs/students/"
    }
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
