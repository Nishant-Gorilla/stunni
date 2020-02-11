//
//  PremiumViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 27/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class PremiumViewController: BaseViewController {

    private var deals: [Deal] = []  {
        didSet {
            tableView.reloadData()
        }
    }
    private var plans: [Plan] = []
    private var detailText: String = "Save up to £300 every month by simply upgrading"
    
    @IBOutlet weak var tableView: UITableView!
    var price: String?
     var id : String?
     var planId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
    }
    
    override func viewWillAppear(_ animated: Bool) {
              showLoader()
               APIHelper.getPremiumOffers(completion: {
                   [weak self] (data, error) in
                   self?.hideLoader()
                   if let (_deals, _details,_plan) = data as? ([Deal]?, String?,[Plan]?) {
                    self?.detailText = _details ?? ""
                       self?.deals = _deals ?? []
                       self?.plans = _plan ?? []
                   }
               })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
           if segue.identifier == "paymentViewControllerSegue" {
            if(id == nil){
                    showAlertWith(title:"Alert", message: "Please select your preferred plan to continue.")
            }else{
                let destinationVC = segue.destination as! PaymentViewController
                      destinationVC.id = id
                      destinationVC.planId = planId
                      destinationVC.price = price
           
            }}
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func upgradeButtonAction(_ sender: Any) {
      
        }
}


//MARK:- UITableView Datasource
extension PremiumViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_offers", for: indexPath) as! OfferCell
            cell.deals = deals
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTblCell", for: indexPath)as!PlanTblCell
            cell.lblDescription.text = detailText
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_price", for: indexPath) as! PriceCell
                cell.plan = self.plans
                cell.tblVewHeight.constant = CGFloat((self.plans.count) * 90)
                cell.tblVew.layoutIfNeeded()
                cell.tblVew.updateConstraintsIfNeeded()
                cell.tblVew.reloadData()
                cell.sendPlanDetail = {[weak self] (id,price,planId)in
                    self?.price = price
                    self?.id = id
                    self?.planId = planId
            }
           
           // cell.lbl_price.text =  price + "/year"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifiers.similarDeals", for: indexPath) as UITableViewCell
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
       }
}
