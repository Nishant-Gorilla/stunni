//
//  CategoriesViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 02/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class CategoriesViewController: BaseViewController {
    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Properties
    private var categoryViewModel: CategoryViewModel!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        categoryViewModel = CategoryViewModel(delegate: self)
         refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
         refreshControl.backgroundColor = UIColor.white
         refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
         collectionView.addSubview(refreshControl)
        }
                        
        @objc func refresh(sender:AnyObject) {
                       // Code to refresh table view
            refreshControl.endRefreshing()
              }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DealsProfileViewControllerSegue" {
            let vc = segue.destination as! DealsProfileViewController
            vc.category = sender as? Category
        }
    }
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryViewModel.numberOfCategories
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryDetailCollectionViewCell", for: indexPath) as? CategoryDetailCollectionViewCell else { return UICollectionViewCell() }
        let imageURL = categoryViewModel.getCategoryPhotoURL(at: indexPath.row)
            let categoryName = categoryViewModel.getCategoryName(at: indexPath.row)
        cell.setData(data: ["imageURL": imageURL, "name": categoryName])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width/2.0) - 1.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categoryViewModel.getCategory(at: indexPath.item)
        performSegue(withIdentifier: "DealsProfileViewControllerSegue", sender: category)
    }
    
}

//MARK:- ViewModel Delegate
extension CategoriesViewController: CategoryViewModelDelegate {
    func reloadData() {
        collectionView.reloadData()
        hideLoader()
    }
    
    func didReceive(error: Error) {
        hideLoader()
        showAlertWith(title: "Error!", message: error.localizedDescription)
    }
}
