//
//  PremiumViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 27/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class PremiumViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_offers", for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_details", for: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_price", for: indexPath) as UITableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifiers.similarDeals", for: indexPath) as UITableViewCell
            return cell
        }
    }
}
