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
    
    private func initVIPImageView() {
        guard vipImageView == nil else {return}
        vipImageView = UIImageView(frame: bounds)
        vipImageView.image = #imageLiteral(resourceName: "flash")
        addSubview(vipImageView)
    }
    
    func showVIP() {
        initVIPImageView()
        vipImageView.isHidden = false
    }
    
    func hideVIP() {
        initVIPImageView()
        vipImageView.isHidden = true
    }
}
