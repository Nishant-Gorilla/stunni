//
//  VIPImageView.swift
//  Stunii
//
//  Created by Admin on 08/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class VIPImageView: UIImageView {
    
    private var vipImageView: UIImageView!
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        let size = CGSize(width: bounds.width/2.0, height: bounds.height/2.0)
//        vipImageView.frame = CGRect(origin: center, size: size)
//    }
    
    private func initVIPImageView() {
        guard vipImageView == nil else {return}
        let size = CGSize(width: bounds.width/2.0, height: bounds.height/2.0)
        vipImageView = UIImageView(frame: CGRect(origin: .zero, size: size))
        //vipImageView.center = center
        vipImageView.image = #imageLiteral(resourceName: "vip")
        vipImageView.contentMode = .scaleAspectFit
        addSubview(vipImageView)
        
        vipImageView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = vipImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        let verticalConstraint = vipImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        let widthConstraint = vipImageView.widthAnchor.constraint(equalToConstant: frame.width/2.0)
        let heightConstraint = vipImageView.heightAnchor.constraint(equalToConstant: frame.height/2.0)
        addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    func showVIP() {
        initVIPImageView()
        vipImageView.isHidden = false
    }
    
    func hideVIP() {
        initVIPImageView()
        vipImageView.isHidden = true
    }
    
    func setVIPImage(deal: Deal) {
        guard let isVip = UserData.loggedInUser?.isVIP, !isVip else {return}
        if deal.isVIP ?? false {
            showVIP()
        }
        else {
            hideVIP()
        }
    }
}
