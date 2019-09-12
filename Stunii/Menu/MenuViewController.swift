//
//  MenuViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 26/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    let dataArray: [(title: String, image: UIImage)] = [
        ("Facebook", #imageLiteral(resourceName: "facebook")),
        ("Twitter", #imageLiteral(resourceName: "twitter")),
        ("Instagram", #imageLiteral(resourceName: "intagram")),
        ("Terms of Service", #imageLiteral(resourceName: "terms-of-service")),
        ("Privacy Policy", #imageLiteral(resourceName: "privacy")),
        ("Cancel Premium", #imageLiteral(resourceName: "terms-of-service")),
        ("Logout", #imageLiteral(resourceName: "logout"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        cell.titleLabel.text = dataArray[indexPath.row].title
        cell.imgView.image = dataArray[indexPath.row].image
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let homeVC = (sideMenuController?.rootViewController as! UINavigationController).viewControllers[0]
        
        if indexPath.row == 0 {
            let fbUrl = "https://www.facebook.com/STUNiiAPP/"
            Utilities.openUrlInSafari(string: fbUrl)
        }
        else if indexPath.row == 1 {
            let twitterUrl
                = "https://twitter.com/stuniiapp?lang=en"
            Utilities.openUrlInSafari(string: twitterUrl)
        }
        else if indexPath.row == 2 {
            let instaUrl
                = "https://www.instagram.com/stuniiapp/?hl=en"
            Utilities.openUrlInSafari(string: instaUrl)
        }
        else if indexPath.row == 3 { //service
            let instaUrl = "https://stunii.com/terms"
            
            Utilities.openUrlInSafari(string: instaUrl)
        }
        else if indexPath.row == 4 { //privacy
            let instaUrl = "https://stunii.com/privacy"
            Utilities.openUrlInSafari(string: instaUrl)
        }
        else if indexPath.row == 5 { // cancel
            let message = "We don’t want you to miss out on our amazing package deals, but we understand if you need to go. You can cancel your deal package by visiting www.stunii.com/cancelpackage and proceeding to ‘Cancel Package'"
            showAlertWith(title: "Cancel Premium", message: message, buttonTitle: "Cancel Premium", clickHandler: {
                     Utilities.openUrlInSafari(string:"https://stunii.com")
            })
        }
        else if indexPath.row == 6 {
            UserData.loggedInUser = nil
            MainScreenUtility.setSignupAsRoot()
        }
        sideMenuController?.toggleLeftView()
    }
}

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView      : UIImageView!
    @IBOutlet weak var titleLabel   : UILabel!
}
