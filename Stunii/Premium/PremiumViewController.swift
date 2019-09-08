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
    
    private var price: String = "9.99"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoader()
        APIHelper.getPremiumOffers(completion: {
            [weak self] (data, error) in
            self?.hideLoader()
            if let (_deals, _price) = data as? ([Deal]?, String?) {
                self?.price = _price ?? "\(POUNDS_STRING)9.99"
                self?.deals = _deals ?? []
            }
        })
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func upgradeButtonAction(_ sender: Any) {
        
    }
}

//MARK:- UITableView Datasource
extension PremiumViewController: UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_details", for: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_price", for: indexPath) as! PriceCell
            cell.lbl_price.text =  price + "/year"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifiers.similarDeals", for: indexPath) as UITableViewCell
            return cell
        }
    }
}
