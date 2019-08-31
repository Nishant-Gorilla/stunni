//
//  CategoryViewModel.swift
//  Stunii
//
//  Created by inderjeet on 29/08/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
class CategoryViewModel: NSObject {
    var delegate: CategoryViewModelDelegate?
    private var categories: [Category] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    
    var numberOfCategories: Int  {
        return categories.count
    }
    
    
    init(delegate: CategoryViewModelDelegate) {
        super.init()
        self.delegate = delegate
        getData()
    }
    
    private func getData() {
        APIHelper.getAllCategories{ [weak self] (data, error) in
            if let err = error {
                self?.delegate?.didReceive(error: err)
            }
            else if let categories = data {
                self?.categories = categories
            }
        }
    }
    
    func getCategoryName(at row: Int) -> String {
        return categories[row].name ?? ""
    }

    func getCategoryPhotoURL(at row: Int) -> String {
        return categories[row].photoURL ?? ""
    }
    
    
    
}

protocol CategoryViewModelDelegate: ReloadDataAndErrorHandler { }
