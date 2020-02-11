//
//  PlanTblCell.swift
//  Stunii
//
//  Created by Ajay Kumar on 19/01/20.
//  Copyright © 2020 Gorilla App Development. All rights reserved.
//

import UIKit

class PlanTblCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var vew: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
