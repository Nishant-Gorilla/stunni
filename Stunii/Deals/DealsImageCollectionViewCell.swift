//
//  DealsImageCollectionViewCell.swift
//  Stunii
//
//  Created by Zap.Danish on 01/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import Kingfisher
class DealsImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView! 
    @IBOutlet weak var nameLabel: UILabel!
    
    func set(data:[String:Any]) {
        nameLabel.text = data["name"] as? String
        let imageURL = URL(string:  data["imageUrl"] as? String ?? "")
        imgView.kf.indicatorType = .activity
        imgView.kf.setImage(with: imageURL)
    }
}
