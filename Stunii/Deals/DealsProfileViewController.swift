//
//  DealsProfileViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 30/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class DealsProfileViewController:BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dealProfileViewModel: DealProfileViewModel!
    struct TVCellIdentifier {
        let collectionView = "cell_collView"
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
        dealProfileViewModel = DealProfileViewModel(delegate: self)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProviderDealsSegue" {
            if let providerDealVC = segue.destination as? ProviderDealsViewController {
                providerDealVC.provider = sender as! Provider
            }
        }
    }
    
}

//MARK:- UITableViewDataSource
extension DealsProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.collectionView, for: indexPath) as! HomeTableViewCell
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.tag = indexPath.row
            cell.collectionView.reloadData()
            return cell
        }
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

extension DealsProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dealProfileViewModel.providersCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cvCellIdentifier.image, for: indexPath) as! DealsImageCollectionViewCell
        let imgUrl = dealProfileViewModel.getProviderImageUrl(at: indexPath.row)
        let name = dealProfileViewModel.getProviderName(at: indexPath.row)
      cell.set(data: ["name":name, "imageUrl": imgUrl])
    //   cell.imgView.cornerRadius = 0.0
        return cell
    }
}

extension DealsProfileViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
            return CGSize(width: 100, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ProviderDealsSegue", sender: dealProfileViewModel.getProvider(at: indexPath.row))
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
