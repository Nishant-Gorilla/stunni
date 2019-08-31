//
//  HomeViewController.swift
//  Stunii
//
//  Created by Uday Bhateja on 23/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import LGSideMenuController

class HomeViewController: BaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var collectionView   : UICollectionView!
    @IBOutlet weak var tableView        : UITableView!
    
    //MARK:- Variables & Constants
    private var viewModel       : HomeViewModel!
    private var tvCellFactory   : HomeTVCellFactory!
    private let cvCellFactory   : HomeCVCellFactory = HomeCVCellFactory()
    private let headerCollectionViewDataSource = HomeCategoriesDataSource()
    
    let category: String = "cell_cat"
    
    //MARK:- VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    //    showLoader()
        
        sideMenuController?.isLeftViewSwipeGestureEnabled   = false
        sideMenuController?.isRightViewSwipeGestureEnabled  = false
        
        viewModel = HomeViewModel(delegate: self)
        tvCellFactory = HomeTVCellFactory(tableView: tableView)
        
        collectionView.dataSource   = headerCollectionViewDataSource
        collectionView.delegate     = headerCollectionViewDataSource
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
        return cvCellFactory.cellFor(collectionView: collectionView, indexPath: indexPath, with: obj!)
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
}

//MARK:- ViewModel Delegate
extension HomeViewController: HomeVMDelegate {
    func reloadData() {
        tableView.reloadData()
        hideLoader()
    }
    
    func didReceive(error: Error) {
        hideLoader()
        showAlertWith(title: "Error!", message: error.localizedDescription)
    }
}
