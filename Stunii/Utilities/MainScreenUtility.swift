//
//  MainScreenUtility.swift
//  Stunii
//
//  Created by Zap.Danish on 24/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class MainScreenUtility {
    class func setRootViewController(window: UIWindow?) {
        let tabBarVC = UIStoryboard(
            name: Storyboard.Name.onboarding,
            bundle: nil).instantiateInitialViewController()
        window?.rootViewController = tabBarVC
    }
    
    class func setSignupAsRoot() {
        let window = UIApplication.shared.keyWindow
        let tabBarVC = UIStoryboard(
            name: Storyboard.Name.signup,
            bundle: nil).instantiateInitialViewController()
        window?.rootViewController = tabBarVC
    }
    
    class func setHomeAsRoot() {
        let window = UIApplication.shared.keyWindow
        let tabBarVC = UIStoryboard(
            name: Storyboard.Name.main,
            bundle: nil).instantiateInitialViewController()
        window?.rootViewController = tabBarVC
    }
}

