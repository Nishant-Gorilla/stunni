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
            return (width - 10.0)
        }
        return (width - 30)/2.10
        
    }
    
    private func getData() {
        let parm = self.delegate?.getRequstParam()
        APIHelper.getAllDeals(param: parm!) { [weak self] (data, error) in
            if let err = error {
                self?.delegate?.didReceive(error: err)
            }
            else if let allDeals = data {
                //sort deals on location base
                var sortModel = [HomeData]()
                if let dist = allDeals.first?.deals.first?.distance , dist > 0
                {
                    for i in allDeals{
                        
                        i.deals = i.deals.sorted(by: {$0.distance! < $1.distance!})
                        sortModel.append(i)
                        
                    }
                }else{
                    sortModel = allDeals
                }
                //                self?.model = allDeals
                self?.model = sortModel
            }
        }
    }
}


protocol HomeVMDelegate: ReloadDataAndErrorHandler {
    
    func getRequstParam()->[String:String]
}
