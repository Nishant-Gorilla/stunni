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
    private var currentVc : UIViewController!
    typealias _actionHanlder = (Deal) -> ()
    var rowActionHandler: _actionHanlder?
    private var deal: Deal?
    private struct CellIdentifiers {
        let text = "cell_text"
        let similarDeals = "cell_similar"
        let sellingFast = "cell_selling"
        let map = "cell_map"
    }
    
    init(tblView: UITableView,view:UIViewController) {
        super.init()
        tableView = tblView
        currentVc = view
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
                    cell.legalLabel.text = deal?.legal ?? ""
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
//                if(deal?.web == ""){
//                let buttonTitle = (deal?.scanForRedeem ?? false) ? "Press for QR Reader" : "Redeem"
//                cell.redeemButton.setTitle(buttonTitle, for: .normal)
//                }else{
//                    cell.redeemButton.setTitle("Open Website", for: .normal)
//                }
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
          cell.leftCountLabel.text = String(deal?.limitByStudent ?? 0 )
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.text, for: indexPath) as! CellText
               cell.dealDescriptionLabel.text = deal?.desc ?? ""
                cell.legalLabel.text = deal?.legal ?? ""
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
            if(deal?.web == ""){
                    let buttonTitle = (deal?.scanForRedeem ?? false) ? "Press for QR Reader" : "Redeem"
                    cell.redeemButton.setTitle(buttonTitle, for: .normal)
                    }else{
                cell.redeemButton.setTitle("Open Website", for: .normal)
                }
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
        return deal?.similarDeals.count ?? 0
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
       
      //  rowActionHandler?(deal!.similarDeals[indexPath.row])
        
        let isUserVip = UserData.loggedInUser?.isVIP ?? false
               let isDealVip = deal!.similarDeals[indexPath.row].isVIP ?? false
               if isUserVip {
                   // show deals
                   rowActionHandler?(deal!.similarDeals[indexPath.row])
               } else {
                   if isDealVip {
                       //open subscription
                    print("Hello")
                    if #available(iOS 13.0, *) {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Premium", bundle:nil)
                    let vc = storyBoard.instantiateViewController(identifier:"PremiumViewController")as!PremiumViewController
            
                    currentVc.navigationController?.pushViewController(vc, animated: true)
                    }
                   } else {
                       //showDeals
                       rowActionHandler?(deal!.similarDeals[indexPath.row])
                   }
               }
    }
    
   
    
}

extension UITableViewCell {

    var viewControllerForTableView : UIViewController?{
        return ((self.superview as? UITableView)?.delegate as? UIViewController)
    }

}
