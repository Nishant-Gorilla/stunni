//
//  HomeCollectionViewCell.swift
//  Stunii
//
//  Created by Zap.Danish on 28/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import Kingfisher
class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(deal: Deal) {
        photoImageView.kf.indicatorType = .activity
        imgView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with: URL(string: deal.photo ?? ""))
        imgView.kf.setImage(with:  URL(string: deal.coverPhoto ?? ""))
        titleLabel.text = deal.title ?? ""
        descriptionLabel.text = deal.desc ?? ""
    }

}
