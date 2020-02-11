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

    @IBOutlet weak var imgView: VIPImageView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dealTitleLabel: UILabel!
    @IBOutlet weak var providerNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(deal: Deal? = nil) {
        photoImageView.kf.indicatorType = .activity
        imgView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with: URL(string: deal?.photo ?? ""))
        imgView.kf.setImage(with:  URL(string: deal?.coverPhoto ?? ""))
        providerNameLabel.text = deal?.provider?.name ?? ""
        dealTitleLabel.text = deal?.title ?? ""
        distanceLabel.text = String(deal?.distance ?? 0) + " mi"
        
        imgView.setVIPImage(deal: deal)
    }

}
