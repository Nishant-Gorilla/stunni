//
//  NearMeController.swift
//  Stunii
//
//  Created by Ajay Kumar on 19/10/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//
    
    import UIKit
    import CoreLocation

    class NearMeController: BaseViewController {
        
        private var locationManager: CLLocationManager!
            @IBOutlet weak var tableView: UITableView!
            var viewModel: SubCategoryDealsViewModel!
            var subCategory: SubCategory?
            var type  = String()
            var refreshControl = UIRefreshControl()
            struct TVCellIdentifier {
                let deal = "cell_deal"
            }
            struct CVCellIdentifier {
                let image = "cell_image"
            }
            
            let cellIdentifier      = TVCellIdentifier()
            let cvCellIdentifier    = CVCellIdentifier()
            var isRefresh = Bool()
        
            override func viewDidLoad() {
                super.viewDidLoad()
                showLoader()
               // viewModel = SubCategoryDealsViewModel(delegate: self, subCategory: subCategory,type:"nearMe")
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
        
        }
        
        //MARK:- UITableViewDataSource
        extension NearMeController: UITableViewDataSource, UITableViewDelegate {
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return viewModel.deals.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.deal, for: indexPath) as! DealTableViewCell
                print(viewModel.deals.count)
                if(viewModel.deals.count != 0){
                cell.set(deal: viewModel.deals[indexPath.row])
                }
                return cell
            }
            
            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return UITableView.automaticDimension
            }
            
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                    let deal = viewModel.deals[indexPath.row]
                    ViewNavigator.navigateToDealFrom(viewController: self, deal: deal)
            }
        }
        
        extension NearMeController: SubCategoryDealsViewModelDelegate {
            func reloadData() {
                tableView.reloadData()
                hideLoader()
            }
            
            func didReceive(error: Error) {
                hideLoader()
                showAlertWith(title: "Error!", message: error.localizedDescription)
            }
            
            
        }



extension NearMeController:CLLocationManagerDelegate
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
                
                 self.viewModel?.getNearMeData()
                isRefresh = false
            }
            else{
                
            viewModel = SubCategoryDealsViewModel(delegate: self, subCategory: subCategory,type:"nearMe")
                tableView.delegate = self
                tableView.dataSource = self

            }

            return}
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locValue = locationManager.location?.coordinate
         if(isRefresh){
                       
                    self.viewModel?.getNearMeData()
                    isRefresh = false
                   }
                   else{
              viewModel = SubCategoryDealsViewModel(delegate: self, subCategory: subCategory,type:"nearMe")
              tableView.delegate = self
              tableView.dataSource = self


                   }

    }
    
}
