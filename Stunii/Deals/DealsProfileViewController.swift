//
//  DealsProfileViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 30/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import  CoreLocation

class DealsProfileViewController:BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var locationManager: CLLocationManager!
    var dealProfileViewModel: DealProfileViewModel!
    var category: Category?
    struct TVCellIdentifier {
        let collectionView = "cell_collView"
        let deal = "cell_deal"
    }
    var isRefresh = Bool()
    struct CVCellIdentifier {
        let image = "cell_image"
        let subCategory = "SubCategoryLabelCollectionViewCell"
    }
    
    let cellIdentifier      = TVCellIdentifier()
    let cvCellIdentifier    = CVCellIdentifier()
     var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
       loadCurrentLocation()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.backgroundColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
         tableView.addSubview(refreshControl)
    }
    

    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        loadCurrentLocation()
        refreshControl.endRefreshing()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProviderDealsSegue" {
            if let providerDealVC = segue.destination as? ProviderDealsViewController {
                providerDealVC.provider = sender as! Provider
            }
        } else if segue.identifier == "SubCategoryDealsViewControllerSegue" {
            if let subCatVC = segue.destination as? SubCategoryDealsViewController {
                subCatVC.subCategory = sender as! SubCategory
            }
        }
    }
    
}

//MARK:- UITableViewDataSource
extension DealsProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealProfileViewModel.deals.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.collectionView, for: indexPath) as! HomeTableViewCell
            cell.collectionViewHeightConstraint.constant = indexPath.row == 0 ? 100 : 30
            cell.collectionView.tag = indexPath.row
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.tag = indexPath.row
            cell.collectionView.reloadData()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.deal, for: indexPath) as! DealTableViewCell
        cell.set(deal: dealProfileViewModel.deals[indexPath.row - 2])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            //ViewNavigator.navigateToDealFrom(viewController: self)
        }
        if indexPath.row > 1 {
            let deal = dealProfileViewModel.deals[indexPath.row - 2]
            ViewNavigator.navigateToDealFrom(viewController: self, deal: deal)
        }
    }
}

extension DealsProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return dealProfileViewModel.providersCount
        } else {
        return dealProfileViewModel.subCategories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cvCellIdentifier.image, for: indexPath) as! DealsImageCollectionViewCell
        let imgUrl = dealProfileViewModel.getProviderImageUrl(at: indexPath.row)
        let name = dealProfileViewModel.getProviderName(at: indexPath.row)
      cell.set(data: ["name":name, "imageUrl": imgUrl])
    //   cell.imgView.cornerRadius = 0.0
        return cell
    } else {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cvCellIdentifier.subCategory, for: indexPath) as! SubCategoryLabelCollectionViewCell
        let subCategory = dealProfileViewModel.subCategories[indexPath.row]
            cell.set(subCategory:subCategory)
            return cell
    }
    }
}

extension DealsProfileViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let height = collectionView.frame.height
        if collectionView.tag == 0 {
            return CGSize(width: 100, height: height)
        }
        return CGSize(width: 100, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
        performSegue(withIdentifier: "ProviderDealsSegue", sender: dealProfileViewModel.getProvider(at: indexPath.row))
        } else {
            let category = dealProfileViewModel.getCategory(at: indexPath.item)
            performSegue(withIdentifier: "SubCategoryDealsViewControllerSegue", sender:category)
        }
    }
}


extension DealsProfileViewController: DealProfileViewModelDelegate {
    func reloadData() {
       tableView.reloadData()
        hideLoader()
    }
    
    func didReceive(error: Error) {
        hideLoader()
        showAlertWith(title: "Error!", message: error.localizedDescription)
    }
    
    
}

extension DealsProfileViewController:CLLocationManagerDelegate
{
    func loadCurrentLocation(){
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            locValue = nil
            
            if(isRefresh){
                
                 self.dealProfileViewModel?.getData()
                isRefresh = false
            }
            else{
                
            dealProfileViewModel = DealProfileViewModel(delegate: self, category: category!)
                tableView.delegate = self
                tableView.dataSource = self

            }

            return}
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locValue = locationManager.location?.coordinate
         if(isRefresh){
                       
                    self.dealProfileViewModel?.getData()
                    isRefresh = false
                   }
                   else{
            dealProfileViewModel = DealProfileViewModel(delegate: self, category: category!)
              tableView.delegate = self
              tableView.dataSource = self


                   }

    }
    
}
