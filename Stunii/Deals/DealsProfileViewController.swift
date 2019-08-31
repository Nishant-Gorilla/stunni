//
//  DealsProfileViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 30/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class DealsProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct TVCellIdentifier {
        let collectionView = "cell_collView"
        let deal = "cell_deal"
    }
    struct CVCellIdentifier {
        let image = "cell_image"
        let label = "cell_label"
    }
    
    let cellIdentifier      = TVCellIdentifier()
    let cvCellIdentifier    = CVCellIdentifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK:- UITableViewDataSource
extension DealsProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row <= 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.collectionView, for: indexPath) as! HomeTableViewCell
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            cell.collectionView.tag = indexPath.row
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier.deal, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90
        }
        if indexPath.row == 1 {
            return 50
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 1 {
            ViewNavigator.navigateToDealFrom(viewController: self)
        }
    }
}

extension DealsProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cvCellIdentifier.label, for: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cvCellIdentifier.image, for: indexPath) as! DealsImageCollectionViewCell
       cell.imgView.cornerRadius = 0.0
        return cell
    }
}

extension DealsProfileViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        
        if collectionView.tag == 0 {
            return CGSize(width: height, height: height)
        }
        return CGSize(width: 100.0, height: height/1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            let imgCell = cell as! DealsImageCollectionViewCell
            imgCell.imgView.cornerRadius = 0.0
            //imgCell.imgView.circular = true
        }
        else {
            let lblCell = cell as! DealsLabelCollectionViewCell
           lblCell.label.cornerRadius = lblCell.label.frame.height/2.0
        }
    }
}
