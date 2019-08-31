//
//  CategoryCollectionViewCell.swift
//  Stunii
//
//  Created by inderjeet on 29/08/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import Kingfisher
class CategoryDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryPhotoImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    
    func setData(data:[String: Any]) {
        if let url = URL(string:data["imageURL"] as! String) {
        categoryPhotoImageView.kf.indicatorType = .activity
        categoryPhotoImageView.kf.setImage(with:url)
        }
        categoryNameLabel.text = data["name"] as? String
    }
}
