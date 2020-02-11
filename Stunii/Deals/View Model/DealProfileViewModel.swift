//
//  DealProfileViewModel.swift
//  Stunii
//
//  Created by inderjeet on 31/08/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
class DealProfileViewModel: NSObject {
    var category: Category?
    var providers: [Provider] = []
    
    var subCategories: [SubCategory] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    var deals:[Deal] = [] 
    
    var delegate: DealProfileViewModelDelegate?
    init(delegate: DealProfileViewModelDelegate?, category: Category) {
        super.init()
        self.category = category
        self.delegate = delegate
        getData()
    }
    var providersCount: Int {
        return providers.count
    }
    func getProviderName(at index: Int) -> String {
        return providers[index].name ?? ""
    }
    func getProvider(at:Int) -> Provider {
        return providers[at]
    }
    
    func getCategory(at: Int) -> SubCategory {
        return subCategories[at]
    }
    
    func getProviderImageUrl(at index: Int) -> String {
        return providers[index].photoURL ?? ""
    }
    
    func getData() {

        let param = "lat=\("\(locValue==nil ? 0.0:locValue.latitude)")&lng=\("\(locValue==nil ? 0.0:locValue.longitude)")"
    
        APIHelper.getAllProviders(param:param){ [weak self] (data, error) in
            if let err = error {
                self?.delegate?.didReceive(error: err)
            }
            else if let providers = data {
                self?.providers = providers
            }
            // Get deals of Category
            if let id = self?.category?.id {
                APIHelper().getCategoryDetail(id: id, completion: { [weak self] (dict, error) in
                    self?.deals = dict?["deals"] as? [Deal] ?? []
                    self?.subCategories = dict?["subCat"] as? [SubCategory] ?? []
                })
        }
        }
    }
}

protocol DealProfileViewModelDelegate:ReloadDataAndErrorHandler {
    
}
