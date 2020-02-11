//
//  ReferralViewModel.swift
//  Stunii
//
//  Created by Ajay Kumar on 20/10/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class ReferralViewModel: NSObject {

    private weak var delegate: ReferralVMDelegate?
    
     var model: [Referral] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    
    
    init(delegate: ReferralVMDelegate) {
        super.init()
        self.delegate = delegate
        getData()
    }
    
    var numberOfRows: Int {
        return model.count
    }
    
    func getData() {
           APIHelper.getReferral(){ [weak self] (data, error) in
               if let err = error {
                   self?.delegate?.didReceive(error: err)
               }
               else if let refrel = data {
                   self?.model = refrel
               }
           }
       }
}


protocol ReferralVMDelegate: ReloadDataAndErrorHandler {
    
}
