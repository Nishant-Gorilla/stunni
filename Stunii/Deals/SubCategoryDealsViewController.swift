//
//  SubCategoryDealsViewController.swift
//  Stunii
//
//  Created by inderjeet on 08/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class SubCategoryDealsViewController: BaseViewController {
        @IBOutlet weak var tableView: UITableView!
        var viewModel: SubCategoryDealsViewModel!
        var subCategory: SubCategory?
        var type  = String()
        struct TVCellIdentifier {
            let deal = "cell_deal"
        }
        struct CVCellIdentifier {
            let image = "cell_image"
        }
        
        let cellIdentifier      = TVCellIdentifier()
        let cvCellIdentifier    = CVCellIdentifier()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            showLoader()
           
            viewModel = SubCategoryDealsViewModel(delegate: self, subCategory: subCategory,type:type)
        }
        
        @IBAction func backButtonClicked(_ sender: Any) {
           
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    //MARK:- UITableViewDataSource
    extension SubCategoryDealsViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.deals.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.deal, for: indexPath) as! DealTableViewCell
            cell.set(deal: viewModel.deals[indexPath.row])
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
    
    extension SubCategoryDealsViewController: SubCategoryDealsViewModelDelegate {
        func reloadData() {
            tableView.reloadData()
            hideLoader()
        }
        
        func didReceive(error: Error) {
            hideLoader()
            showAlertWith(title: "Error!", message: error.localizedDescription)
        }
        
        
    }

