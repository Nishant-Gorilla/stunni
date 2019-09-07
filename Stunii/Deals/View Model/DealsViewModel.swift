//
//  DealsViewModel.swift
//  Stunii
//
//  Created by inderjeet on 07/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//



import Foundation
class DealsViewModel: NSObject {
    var deal: Deal? {
        didSet {
            delegate?.reloadData()
        }
    }
    var delegate: DealsViewModelDelegate?
    init(dealId:String ,delegate: DealsViewModelDelegate?) {
        super.init()
        self.delegate = delegate
        getData(id: dealId)
    }
   
    private func getData(id:String) {
        APIHelper.getDealDetail(id: id){ [weak self] (data, error) in
            if let err = error {
                self?.delegate?.didReceive(error: err)
            }
            else if let deal = data {
                self?.deal = deal
            }
        }
    }
}

protocol DealsViewModelDelegate:ReloadDataAndErrorHandler { }
