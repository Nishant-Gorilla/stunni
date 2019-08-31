//
//  ViewNavigator.swift
//  Stunii
//
//  Created by Zap.Danish on 30/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class ViewNavigator {
    
    class func navigateToDealFrom(viewController: UIViewController) {
        
        let dealsStoryboard = UIStoryboard(name: Storyboard.Name.deals, bundle: nil)
        let dealsVC = dealsStoryboard
            .instantiateViewController(withIdentifier: Storyboard.Identifier.deal)
        viewController.navigationController?.pushViewController(dealsVC, animated: true)
    }
    
    class func navigateToDealsProfile(from vc: UIViewController) {
        let dealsStoryboard = UIStoryboard(name: Storyboard.Name.deals, bundle: nil)
        let dealsVC = dealsStoryboard.instantiateInitialViewController()!
        vc.navigationController?.pushViewController(dealsVC, animated: true)
    }
    
}
