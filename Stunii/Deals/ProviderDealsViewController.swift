//
//  ProviderDealsViewController.swift
//  Stunii
//
//  Created by inderjeet on 05/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class ProviderDealsViewController: BaseViewController {
    
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var offerFromLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ProviderDealsViewModel!
    var provider: Provider?
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
       // showLoader()
        viewModel = ProviderDealsViewModel(delegate: self)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK:- UITableViewDataSource
extension ProviderDealsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.deal, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            //ViewNavigator.navigateToDealFrom(viewController: self)
        }
    }
}

extension ProviderDealsViewController: ProviderDealsViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
        hideLoader()
    }
    
    func didReceive(error: Error) {
        hideLoader()
        showAlertWith(title: "Error!", message: error.localizedDescription)
    }
    
    
}
