//
//  HomeTableViewCell.swift
//  Stunii
//
//  Created by Zap.Danish on 28/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var redeemButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
