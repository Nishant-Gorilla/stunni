//
//  DealsViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 27/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class DealsViewController: BaseViewController {
    var dealsViewModel: DealsViewModel?

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
  
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var ratingStarImageVIew: UIImageView!
    @IBOutlet weak var everyDayLabel: UILabel!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var tvCellFactory: DealsTVCellFactory!
    var deal: Deal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        dealsViewModel = DealsViewModel(dealId:deal?.id ?? "", delegate: self)
        tvCellFactory = DealsTVCellFactory(tblView: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QRScannerView" {
            // 0 for camera and 1 for  selected image
            (segue.destination as? QRScannerViewController)?.type = 0
        }
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setData() {
        let deal = dealsViewModel?.deal
       
         titleLabel.text = deal?.title ?? ""
         distanceLabel.text = String(deal?.distance ?? 0)
         ratingCountLabel.text = String(deal?.ratings ?? 0)
        subTitleLabel.text = deal?.provider?.name ?? ""
        
         //everyDayLabel.text =
        providerImageView.kf.indicatorType = .activity
        coverImageView.kf.indicatorType = .activity
        providerImageView.kf.setImage(with: URL(string:deal?.provider?.photoURL ?? ""))
        coverImageView.kf.setImage(with: URL(string:deal?.coverPhoto ?? ""))
        tableView.reloadData()
    }
  
    
    @objc func redeemButtonAction(_ sender: UIButton) {
        if deal?.scanForRedeem ?? false {
            //Open scanner
            performSegue(withIdentifier: "QRScannerView", sender: nil)
        } else {
            //Hit redeem api
        }
    }
    
}

//MARK:- TableView Datasource
extension DealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvCellFactory.cellForRowAt(indexPath: indexPath, deal:dealsViewModel?.deal)
        (cell as? HomeTableViewCell)?.redeemButton.addTarget(self, action: #selector(redeemButtonAction(_:)), for: .touchUpInside)
        return cell
    }
    
  
}

extension DealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 75.0
        }
        return UITableView.automaticDimension
    }
}

//MARK:- Cell classes

class CellText: UITableViewCell {
    
    @IBOutlet weak var dealDescriptionLabel: UILabel!
}

class CellSimilar: UITableViewCell {
    
}
class CellSelling: UITableViewCell {
    @IBOutlet weak var fireHotImageView: UIImageView!
    @IBOutlet weak var sellingFastLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var leftCountLabel: UILabel!
    
}

class CellMap: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var getMeThereButton: UIButton!
    @IBOutlet weak var catchACabButton: UIButton!
}

extension DealsViewController: DealsViewModelDelegate {
    func reloadData() {
       setData()
        hideLoader()
    }
    
    func didReceive(error: Error) {
        hideLoader()
        showAlertWith(title: "Error!", message: error.localizedDescription)
    }
    
}
