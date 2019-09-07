//
//  ProviderDealsViewController.swift
//  Stunii
//
//  Created by inderjeet on 05/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
class ProviderDealsViewModel: NSObject {
    var provider: Provider? {
        didSet {
            delegate?.reloadData()
        }
    }
    var deals:[Deal] = []
    var delegate: ProviderDealsViewModelDelegate?
    init(delegate: ProviderDealsViewModelDelegate?) {
        super.init()
        self.delegate = delegate
        getData()
    }
    var providerDealsCount: Int {
        return deals.count
    }
    func getProvider() -> Provider? {
        return provider
    }
  
    private func getData() {
//        APIHelper.getAllProviders{ [weak self] (data, error) in
//            if let err = error {
//                self?.delegate?.didReceive(error: err)
//            }
//            else if let providers = data {
//                self?.providers = providers
//            }
//        }
    }
}

protocol ProviderDealsViewModelDelegate:ReloadDataAndErrorHandler { }
