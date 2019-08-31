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
                 indexPath: IndexPath, with data: HomeData) -> UICollectionViewCell {
        if data.isFeatured {
            return cellForFeatured(collectionView: collectionView,
                            indexPath: indexPath, with: data.deals[indexPath.row])
        }
        else {
            return cellForDeals(collectionView: collectionView,
                         indexPath: indexPath, with: data.deals[indexPath.row])
        }
    }
    
    private func cellForDeals(collectionView: UICollectionView,
                 indexPath: IndexPath, with data: Deal) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVCell.Identifier.deal, for: indexPath)
        return cell
    }
    
    private func cellForFeatured(collectionView: UICollectionView,
                         indexPath: IndexPath, with data: Deal) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVCell.Identifier.home, for: indexPath)
        return cell
    }
    
}
