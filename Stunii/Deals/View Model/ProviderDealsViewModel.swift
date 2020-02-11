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
    var deals:[Deal] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    var delegate: ProviderDealsViewModelDelegate?
    init(delegate: ProviderDealsViewModelDelegate?, provider: Provider?) {
        super.init()
        self.provider = provider
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
        APIHelper().getProviderDetail(id: provider?.id ?? ""){ [weak self] (data, error) in
            if let err = error {
                self?.delegate?.didReceive(error: err)
            }
            else if let deals = data {
                self?.deals = deals
            }
        }

    }
}

protocol ProviderDealsViewModelDelegate:ReloadDataAndErrorHandler { }
