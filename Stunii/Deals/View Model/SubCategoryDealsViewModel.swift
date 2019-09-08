//
//  SubCategoryDealsViewModel.swift
//  Stunii
//
//  Created by inderjeet on 08/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation


//
//  ProviderDealsViewController.swift
//  Stunii
//
//  Created by inderjeet on 05/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
class SubCategoryDealsViewModel: NSObject {
    var subCategory: SubCategory?
    var deals:[Deal] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    var isProvider: Bool = false
    var delegate: SubCategoryDealsViewModelDelegate?
    init(delegate: SubCategoryDealsViewModelDelegate?, subCategory:SubCategory?) {
        super.init()
        self.subCategory = subCategory
        self.delegate = delegate
        
        getData()
    }
    var dealsCount: Int {
        return deals.count
    }
    
    private func getData() {
            APIHelper().getSubCategoryDetail(id: subCategory?.id ?? ""){ [weak self] (data, error) in
                if let err = error {
                    self?.delegate?.didReceive(error: err)
                }
                else if let deals = data {
                    self?.deals = deals
                }
            }
        
        
    }
}

protocol SubCategoryDealsViewModelDelegate:ReloadDataAndErrorHandler { }