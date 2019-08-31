//
//  HomeViewModel.swift
//  Stunii
//
//  Created by Zap.Danish on 15/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    
    private weak var delegate: HomeVMDelegate?
    
    private var model: [HomeData] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    
    
    init(delegate: HomeVMDelegate) {
        super.init()
        self.delegate = delegate
        getData()
    }
    
    var numberOfRows: Int {
        return model.count
    }
    
    func modelObjectAt(index: Int) -> HomeData? {
        return model[index]
    }
    
    func heightForObjectAt(index: Int) -> CGFloat {
        if modelObjectAt(index: index)?.isFeatured ?? false {
            return 260.0
        }
        else {
            return 220.0
        }
    }
    
    func numberOfItemsAt(index: Int) -> Int {
        return modelObjectAt(index: index)?.deals.count ?? 0
    }
    
    func itemWidthWithCollectionView(width: CGFloat, for index: Int) -> CGFloat {
        if modelObjectAt(index: index)?.isFeatured ?? false {
            return width/1.15
        }
        return (width - 30)/2.10
        
    }
    
    private func getData() {
        APIHelper.getAllDeals { [weak self] (data, error) in
            if let err = error {
                self?.delegate?.didReceive(error: err)
            }
            else if let allDeals = data {
                self?.model = allDeals
            }
        }
    }
}


protocol HomeVMDelegate: ReloadDataAndErrorHandler {
    
}
