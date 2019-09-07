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
    
    func cellForRowAt(indexPath: IndexPath, deal:Deal? = nil) -> UITableViewCell {
        self.deal = deal
        let cellIdentifiers = CellIdentifiers()
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.sellingFast, for: indexPath) as! CellSelling
        
//fireHotImageView
//sellingFastLabel
//leftLabel
//cell.leftCountLabel.text = deal.
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.text, for: indexPath) as! CellText
               cell.dealDescriptionLabel.text = deal?.desc ?? ""
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.similarDeals, for: indexPath) as! HomeTableViewCell
            let nib = UINib(nibName: CVCell.Name.deals, bundle: nil)
            cell.collectionView.register(nib, forCellWithReuseIdentifier: CVCell.Identifier.deal)
            cell.redeemButton.
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            cell.label.text = "Similar Deals"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.map, for: indexPath) as! CellMap
            //mapView
            return cell
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
}
