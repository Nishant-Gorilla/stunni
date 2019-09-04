//
//  ProfileViewController.swift
//  Stunii
//
//  Created by inderjeet on 02/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var coverPicImageView: UIImageView!
    
    @IBOutlet weak var verifiedUntilLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var universityNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        // Do any additional setup after loading the view.
    }
    
    func setData() {
        guard let user = UserData.loggedInUser else { return }
        let name = (user.fname ?? "") + " " + (user.lname ?? "")
        userNameLabel.text = name
        universityNameLabel.text = user.institution ?? ""
    }

}
