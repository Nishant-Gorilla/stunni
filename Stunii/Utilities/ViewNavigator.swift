//
//  ViewNavigator.swift
//  Stunii
//
//  Created by Zap.Danish on 30/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class ViewNavigator {
    

    class func navigateToDealFrom(viewController: UIViewController, deal:Deal?) {
        if let deal = deal {
        checkPremiumDeal(viewController: viewController, deal: deal)
        }
    }
    
    class func navigateToDealsProfile(from vc: UIViewController) {
        let dealsStoryboard = UIStoryboard(name: Storyboard.Name.deals, bundle: nil)
        let dealsVC = dealsStoryboard.instantiateInitialViewController()!
        vc.navigationController?.pushViewController(dealsVC, animated: true)
    }
    
    class func checkPremiumDeal(viewController: UIViewController, deal: Deal) {
        let isUserVip = UserData.loggedInUser?.isVIP ?? false
        let isDealVip = deal.isVIP ?? false
        if isUserVip {
            showDealView(from: viewController, deal: deal)
        } else {
            if isDealVip {
                //open subscription
                showPremiumView(from: viewController)
            } else {
              showDealView(from: viewController, deal: deal)
            }
        }
        
    }
    
    private class func showPremiumView(from viewController: UIViewController) {
        let story = UIStoryboard(name: "Premium", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "PremiumViewController")
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    private class func showDealView(from: UIViewController, deal: Deal) {
        let dealsStoryboard = UIStoryboard(name: Storyboard.Name.deals, bundle: nil)
        let dealsVC = dealsStoryboard
            .instantiateViewController(withIdentifier: Storyboard.Identifier.deal) as! DealsViewController
        dealsVC.deal = deal
        from.navigationController?.pushViewController(dealsVC, animated: true)
    }
    
}
