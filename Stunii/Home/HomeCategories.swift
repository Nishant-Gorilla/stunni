//
//  HomeCategories.swift
//  Stunii
//
//  Created by Zap.Danish on 16/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class HomeCategory {
    var title       : String = ""
    var selected    : Bool = false
    
    private init(title: String, selected: Bool) {
        self.title = title
        self.selected = selected
    }
    
    class func get() -> [HomeCategory] {
        let homeCategories = [
            HomeCategory(title: "All", selected: true),
            HomeCategory(title: "Flash Deals", selected: false),
            HomeCategory(title: "Food & Drinks", selected: false)
        ]
        return homeCategories
    }
}

class HomeCategoriesDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let data = HomeCategory.get()
    let category: String = "cell_cat"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: category, for: indexPath) as! CategoryCollectionViewCell
        cell.label.text = data[indexPath.row].title
        cell.selectedView.isHidden = !data[indexPath.row].selected
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height  = collectionView.frame.height
        let width   = collectionView.frame.width/3.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        data.forEach({$0.selected=false})
        data[indexPath.row].selected = true
        collectionView.reloadData()
    }
}
