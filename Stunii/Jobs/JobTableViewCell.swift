//
//  JobTableViewCell.swift
//  Stunii
//
//  Created by inderjeet on 04/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import Kingfisher
class JobTableViewCell: UITableViewCell {
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var jobRateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func set(job: Job) {
        jobTitleLabel.text = job.jobName
        companyNameLabel.text = job.companyName
        addressLabel.text = job.jobAddress
        jobTypeLabel.text = job.jobType
        jobRateLabel.text = job.jobRate
        
        companyImageView.kf.indicatorType = .activity
        companyImageView.kf.setImage(with: URL(string:job.companyImage ?? ""))
        
    }
}
