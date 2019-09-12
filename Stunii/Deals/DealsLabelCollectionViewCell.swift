//
//  DealsLabelCollectionViewCell.swift
//  Stunii
//
//  Created by Zap.Danish on 01/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class SubCategoryLabelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        label.layer.cornerRadius = 12.5
        label.layer.masksToBounds = true
    }
    
    func set(subCategory: SubCategory) {
        label.text = subCategory.subCategoryName ?? ""
    }
}
