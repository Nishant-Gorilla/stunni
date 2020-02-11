//
//  HomeCVCellFactory.swift
//  Stunii
//
//  Created by Zap.Danish on 16/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class HomeCVCellFactory: NSObject {
    
    private var collView: UICollectionView!
    
    func cellFor(collectionView: UICollectionView,
                 indexPath: IndexPath, with data: HomeData? = nil) -> UICollectionViewCell {
//        data.deals = data.deals.sorted {
//            $0.distance! < $1.distance!
//        }
        if data?.isFeatured ?? false {
            return cellForFeatured(collectionView: collectionView,
                                   indexPath: indexPath, with: (data?.deals[safe:indexPath.row]))
            
        }
        else {
            return cellForDeals(collectionView: collectionView,
                                indexPath: indexPath, with: (data?.deals[safe:indexPath.row]))
        }
    }
    
    private func cellForDeals(collectionView: UICollectionView,
                 indexPath: IndexPath, with data: Deal? = nil) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVCell.Identifier.deal, for: indexPath) as! DealsCollectionViewCell
        cell.set(deal: data)
        cell.titleLabel.text = data?.provider?.name
        cell.descLabel.text = data?.meta_title ?? ""
        cell.distancLabel.text = String(data?.distance ?? 0.0)+" mi"
        return cell
    }
    
    private func cellForFeatured(collectionView: UICollectionView,
                         indexPath: IndexPath, with data: Deal? = nil) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVCell.Identifier.home, for: indexPath) as! HomeCollectionViewCell
        cell.set(deal: data)
        return cell
    }
    
}
