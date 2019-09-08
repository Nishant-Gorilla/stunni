//
//  DealTableViewCell.swift
//  Stunii
//
//  Created by inderjeet on 08/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import Kingfisher
class DealTableViewCell: UITableViewCell {
    @IBOutlet weak var coverImageView: VIPImageView!
    
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var openingDayLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var providerTitle: UILabel!
    @IBOutlet weak var dealTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(deal:Deal) {
        coverImageView.kf.indicatorType = .activity
       providerImageView.kf.indicatorType = .activity
        coverImageView.kf.setImage(with: URL(string: deal.coverPhoto ?? ""))
        providerImageView.kf.setImage(with: URL(string: deal.photo ?? ""))
        ratingCountLabel.text = String(deal.ratings ?? 0)
        
        var openDay = "Everyday"
        let startDay = deal.startDay ?? ""
        let endDay = deal.endDay ?? ""
        if (startDay+endDay).trimSpace() != "" {
        openDay = startDay + " to " + endDay
        }
        openingDayLabel.text = openDay
        distanceLabel.text = "\(deal.distance ?? 0)mi"
        providerTitle.text = deal.provider?.name ?? "Provider"
        dealTitle.text = deal.title ?? ""
        
        coverImageView.setVIPImage(deal: deal)
        
    }

}
