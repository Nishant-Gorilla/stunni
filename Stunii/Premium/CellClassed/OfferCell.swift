//
//  TableViewCell.swift
//  Stunii
//
//  Created by inderjeet on 07/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
class OfferCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var deals:[Deal] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "DealsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell_deals")
    }
 override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

extension OfferCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_deals", for: indexPath) as! DealsCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width/2.25
        return CGSize(width: width, height: height)
    }
    
}

extension OfferCell: UICollectionViewDelegate {
    
}
