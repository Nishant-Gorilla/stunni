//
//  PriceCell.swift
//  Stunii
//
//  Created by Admin on 08/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class PriceCell: UITableViewCell {
   // @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var tblVew: UITableView!
    @IBOutlet weak var tblVewHeight: NSLayoutConstraint!
    var sendPlanDetail: ((String?,String?,String?)->())?
    
    var plan:[Plan] = [] 
      override func awakeFromNib() {
           super.awakeFromNib()
           tblVew.delegate = self
           tblVew.dataSource = self
       }
    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
           // Configure the view for the selected state
       }
}

extension PriceCell : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Plan count is \(plan.count)")
        return plan.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVew.dequeueReusableCell(withIdentifier:"PlanTblCell", for:indexPath)as!PlanTblCell
        cell.lblDescription?.text = plan[indexPath.row].description
        print(tblVew.contentSize.height)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       sendPlanDetail?(plan[indexPath.row].id,plan[indexPath.row].price,plan[indexPath.row].plan_id)
    }
   
}
