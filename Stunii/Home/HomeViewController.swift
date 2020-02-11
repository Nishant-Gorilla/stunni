//
//  HomeViewController.swift
//  Stunii
//
//  Created by Uday Bhateja on 23/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import LGSideMenuController
import CoreLocation

class HomeViewController: BaseViewController {

    private var locationManager: CLLocationManager!

    //MARK:- IBOutlet
    @IBOutlet weak var collectionView   : UICollectionView!
    @IBOutlet weak var tableView        : UITableView!
    

    
    //MARK:- Variables & Constants
    private var viewModel       : HomeViewModel!
    private var tvCellFactory   : HomeTVCellFactory!
    private let cvCellFactory   : HomeCVCellFactory = HomeCVCellFactory()
    private let headerCollectionViewDataSource = HomeCategoriesDataSource()
    var timer: Timer!
     var nextIndex = 0
    let category: String = "cell_cat"
    var refreshControl = UIRefreshControl()
    var isRefresh = Bool()
    
    //MARK:- VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
       loadCurrentLocation()
        self.tabBarController?.tabBar.isHidden = false
      refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
      refreshControl.backgroundColor = UIColor.white
      refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
     tableView.addSubview(refreshControl)
        }
                  
        @objc func refresh(sender:AnyObject) {
                 // Code to refresh table view
            isRefresh = true
            loadCurrentLocation()
            refreshControl.endRefreshing()
        }
    
    
    @objc func viewSetupAction(){
        
        sideMenuController?.isLeftViewSwipeGestureEnabled   = false
        sideMenuController?.isRightViewSwipeGestureEnabled  = false
        
        viewModel = HomeViewModel(delegate: self)
        tvCellFactory = HomeTVCellFactory(tableView: tableView)
        
        collectionView.dataSource   = headerCollectionViewDataSource
        collectionView.delegate     = headerCollectionViewDataSource
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playSlideShow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if timer != nil { timer.invalidate() }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dealViewControllerSegue" {
            if let deal = sender as? Deal {
                (segue.destination as? DealsViewController)?.deal = deal
            }
        }
    }
    
    @IBAction func serchAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchDealVC") as! SearchDealVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func playSlideShow() {
        if timer != nil { timer.invalidate() }
        let collectionView = (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeTableViewCell)?.collectionView
        let totalRows = collectionView?.numberOfItems(inSection: 0)
       
        timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: {  [weak self] (_) in
            guard let _self = self else { return }
            DispatchQueue.main.async {
                if self?.tableView.indexPathsForVisibleRows?.contains(IndexPath(row: 0, section: 0)) ?? false {
                    let _collectionView = (self?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HomeTableViewCell)?.collectionView
                    _collectionView?.scrollToItem(at: IndexPath(row: _self.nextIndex, section: 0), at: .left, animated: true)
                _self.nextIndex += 1
                if _self.nextIndex == _collectionView?.numberOfItems(inSection: 0) { _self.nextIndex = 0}
                }
            }
        })
    }
    
    //MARK:- IBActions
    
    @IBAction func unwindFromSearch(_ sender: UIStoryboardSegue) {
    }
}

//MARK:- UITableView Datasource Delegate
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = viewModel.modelObjectAt(index: indexPath.row)!
        
        return tvCellFactory.cellFor(indexPath: indexPath, with: obj, vc: self)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForObjectAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let _cell = cell as? HomeTableViewCell else {return}
        _cell.collectionView.reloadData()
    }
}

//MARK:- UICollectionView Datasource Delegate
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tableViewIndex = collectionView.tag
        return viewModel.numberOfItemsAt(index: tableViewIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tableViewIndex = collectionView.tag
       
        let obj = viewModel.modelObjectAt(index: tableViewIndex)
        return cvCellFactory.cellFor(collectionView: collectionView, indexPath: indexPath, with: obj)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            nextIndex = indexPath.item
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tableViewIndex = collectionView.tag
        let height = collectionView.frame.height
        let width = viewModel.itemWidthWithCollectionView(
            width: collectionView.frame.width, for: tableViewIndex)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let obj = viewModel.modelObjectAt(index: collectionView.tag)
        let deal = obj?.deals[indexPath.row]
        let isUserVip = UserData.loggedInUser?.isVIP ?? false
        let isDealVip = deal?.isVIP ?? false
        if isUserVip {
            // show deals
            performSegue(withIdentifier: "dealViewControllerSegue", sender: deal)
        } else {
            if isDealVip {
                //open subscription
                 performSegue(withIdentifier: "premiumViewControllerSegue", sender: deal)
            } else {
                //showDeals
                performSegue(withIdentifier: "dealViewControllerSegue", sender: deal)
            }
        }
    }
    
}

//MARK:- ViewModel Delegate
extension HomeViewController: HomeVMDelegate {
    func reloadData() {
        tableView.reloadData()
        hideLoader()
       
        playSlideShow()
    }
    
    func didReceive(error: Error) {
        hideLoader()
        showAlertWith(title: "Error!", message: error.localizedDescription)
    }
    
    func getRequstParam() -> [String:String]
    {
        var data : [String:String] = [:]
        if locValue==nil
        {
             data = ["isActive":"true","type":"1","page":"1"]

        }else{
             data = ["isActive":"true","type":"1","lat":"\(locValue==nil ? 0.0:locValue.latitude)","lon":"\(locValue==nil ? 0.0:locValue.longitude)","page":"1"]

        }
        print(data)
        return data
    }
}


extension HomeViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            if collectionView.tag == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.playSlideShow()
                }
            }
        }
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            if collectionView.tag == 0 {
                timer.invalidate()
            }
        }
    }
}


extension HomeViewController:CLLocationManagerDelegate
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
                
                 self.viewModel.fetchData()
                isRefresh = false
            }
            else{
            self.viewSetupAction()
            }

            return}
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locValue = locationManager.location?.coordinate
         if(isRefresh){
                       
                        self.viewModel.fetchData()
                       isRefresh = false
                   }
                   else{
                   self.viewSetupAction()
                   }

    }
    
}
