//
//  DealsCollectionViewCell.swift
//  
//
//  Created by Zap.Danish on 27/06/19.
//

import UIKit

class DealsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: VIPImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(deal: Deal) {
        photoImageView.kf.indicatorType = .activity
        coverImageView.kf.indicatorType = .activity
        photoImageView.kf.setImage(with: URL(string: deal.photo ?? ""))
        coverImageView.kf.setImage(with:  URL(string: deal.coverPhoto ?? ""))
        titleLabel.text = deal.title ?? ""
        descLabel.text = deal.desc ?? ""
        
        coverImageView.setVIPImage(deal: deal)
    }

}
