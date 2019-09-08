//
//  DealsTVCellFactory.swift
//  Stunii
//
//  Created by Zap.Danish on 27/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class DealsTVCellFactory: NSObject {
    
    private var tableView: UITableView!
    typealias _actionHanlder = (Deal) -> ()
    var rowActionHandler: _actionHanlder?
    private var deal: Deal?
    private struct CellIdentifiers {
        let text = "cell_text"
        let similarDeals = "cell_similar"
        let sellingFast = "cell_selling"
        let map = "cell_map"
    }
    
    init(tblView: UITableView) {
        super.init()
        tableView = tblView
    }
    
    func cellForRowAt(indexPath: IndexPath, deal:Deal? = nil, rowAction:_actionHanlder? = nil) -> UITableViewCell {
        self.rowActionHandler = rowAction
        let isUnlimitedDeals = deal?.redeemType == "unlimited"
        self.deal = deal
        let cellIdentifiers = CellIdentifiers()
        if isUnlimitedDeals {
            switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.text, for: indexPath) as! CellText
                    cell.dealDescriptionLabel.text = deal?.desc ?? ""
                return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.map, for: indexPath) as! CellMap
                    //mapView
                    if let location = deal?.location {
                        cell.set(location: location, address: deal?.address)
                    }
                    return cell
                case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.similarDeals, for: indexPath) as! HomeTableViewCell
                let nib = UINib(nibName: CVCell.Name.deals, bundle: nil)
                cell.collectionView.register(nib, forCellWithReuseIdentifier: CVCell.Identifier.deal)
                let buttonTitle = (deal?.scanForRedeem ?? false) ? "Press for QR Reader" : "Redeem"
                cell.redeemButton.setTitle(buttonTitle, for: .normal)
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
                cell.label.text = "Similar Deals"
                return cell
                default:
                return UITableViewCell()
            }
        } else {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.sellingFast, for: indexPath) as! CellSelling
cell.leftCountLabel.text = String(deal?.limitTotal ?? 0 )
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.text, for: indexPath) as! CellText
               cell.dealDescriptionLabel.text = deal?.desc ?? ""
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.map, for: indexPath) as! CellMap
            if let location = deal?.location {
                cell.set(location: location, address: deal?.address)
            }
            //mapView
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.similarDeals, for: indexPath) as! HomeTableViewCell
            let nib = UINib(nibName: CVCell.Name.deals, bundle: nil)
            cell.collectionView.register(nib, forCellWithReuseIdentifier: CVCell.Identifier.deal)
              let buttonTitle = (deal?.scanForRedeem ?? false) ? "Press for QR Reader" : "Redeem"
            cell.redeemButton.setTitle(buttonTitle, for: .normal)
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            cell.label.text = "Similar Deals"
            return cell
        default:
            return UITableViewCell()
        }
        }
    }
    
}



extension DealsTVCellFactory: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVCell.Identifier.deal, for: indexPath) as! DealsCollectionViewCell
        if deal != nil {
            cell.set(deal: deal!.similarDeals[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width/2.25
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        rowActionHandler?(deal!.similarDeals[indexPath.row])
    }
}
