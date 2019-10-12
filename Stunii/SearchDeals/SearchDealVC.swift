//
//  SearchDealVC.swift
//  Stunii
//
//  Created by Harsh Rajput on 26/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class SearchDealVC: BaseViewController {

    @IBOutlet var table:UITableView!
    @IBOutlet var searchText:UITextField!
    struct TVCellIdentifier {
        let collectionView = "cell_collView"
        let deal = "cell_deal"
    }
    
    private var viewModel       : HomeViewModel!
    let cellIdentifier      = TVCellIdentifier()

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        viewModel = HomeViewModel(delegate: self)


        
    }
    
    @IBAction func backAction(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func searchAction(_ sender:UIButton){
        showLoader()
        viewModel = HomeViewModel(delegate: self)

    }


}



extension SearchDealVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsAt(index: section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.deal, for: indexPath) as! DealTableViewCell
        
        let obj = viewModel.modelObjectAt(index: indexPath.section)
        cell.set(deal:(obj?.deals[indexPath.row])!)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = viewModel.modelObjectAt(index: indexPath.section)
        let deal = obj?.deals[indexPath.row]
        ViewNavigator.navigateToDealFrom(viewController: self, deal: deal)
        
    }
}
//MARK:- ViewModel Delegate
extension SearchDealVC: HomeVMDelegate {
    func reloadData() {
        table.reloadData()
        hideLoader()
        
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
             data = ["isActive":"true","type":"1","page":"1","search":self.searchText.text ?? ""]

        }else{
             data = ["isActive":"true","type":"1","lat":"\(locValue==nil ? 0.0:locValue.latitude)","lon":"\(locValue==nil ? 0.0:locValue.longitude)","page":"1","search":self.searchText.text ?? ""]
        }


        

        
        return data
    }
}
