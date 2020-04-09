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
                                   indexPath: indexPath, with: data)
            
        }
        else {
            return cellForDeals(collectionView: collectionView,
                                indexPath: indexPath, with: data)
        }
    }
    
    private func cellForDeals(collectionView: UICollectionView,
                 indexPath: IndexPath, with data: HomeData? = nil) -> UICollectionViewCell {
        var indexPathCmp = 0
        if (data?.deals.count)! < 20{
            indexPathCmp = (data?.deals.count)!-1
        }
        else{
            indexPathCmp = 20
        }
        if data?.name != "Featured"&&indexPath.row==indexPathCmp{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVCell.Identifier.seemore, for: indexPath) as! SeeMoreCollectionViewCell
            return cell
        }
        else{
        let deal = (data?.deals[safe:indexPath.row])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVCell.Identifier.deal, for: indexPath) as! DealsCollectionViewCell
        cell.set(deal: deal)
        cell.titleLabel.text = deal?.provider?.name
        cell.descLabel.text = deal?.meta_title ?? ""
        cell.distancLabel.text = String(deal?.distance ?? 0.0)+" mi"
        return cell
    }
    }
    
    private func cellForFeatured(collectionView: UICollectionView,
                         indexPath: IndexPath, with data: HomeData? = nil) -> UICollectionViewCell {
        let deal = (data?.deals[safe:indexPath.row])

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVCell.Identifier.home, for: indexPath) as! HomeCollectionViewCell
        cell.set(deal: deal)
        return cell
    }
    
}
