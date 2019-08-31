//
//  OnboardingViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 24/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import AVKit

class OnboardingViewController: BaseViewController {

    //MARK: IBOutlets
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bgImageView: UIImageView!
    
    //MARK: Variables & Constant
    private let cellIdentifier = "cell_onboarding"
    private let images: [UIImage] = [
        #imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "3"), #imageLiteral(resourceName: "4") , #imageLiteral(resourceName: "5"), #imageLiteral(resourceName: "6"), #imageLiteral(resourceName: "7"), #imageLiteral(resourceName: "8")
    ]
    private var gradientLayer: CAGradientLayer!
    private let gradientColors: [CGColor] = [
        UIColor(hex: 0xe22426).withAlphaComponent(0.60).cgColor,
        UIColor(hex: 0xf3c814).withAlphaComponent(0.70).cgColor
    ]
    
    private var player: AVPlayer!
    
    private func playVideo() {
        
        guard player == nil else {
            return
        }

        guard let path = Bundle.main.path(forResource: "video", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = bgImageView.bounds
        playerLayer.videoGravity = .resizeAspectFill
        bgImageView.layer.addSublayer(playerLayer)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) {
            [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }

        
        player.play()
//        
//        let playerController = AVPlayerViewController()
//        playerController.player = player
//        present(playerController, animated: true) {
//            player.play()
//        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scalePageControl()
        playVideo()
        //setGradient()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        player.pause()
    }
    
    private func scalePageControl() {
        guard pageControl.isHidden else {
            return
        }
        pageControl.transform = CGAffineTransform(
            scaleX: 1.25, y: 1.25)
        pageControl.isHidden = false
    }
    
    private func setGradient() {
        guard gradientLayer == nil else {
            return
        }
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = bgImageView.bounds
        bgImageView.layer.addSublayer(gradientLayer)
    }
}

//MARK:- CollectionView DataSource Delegates
extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = images.count
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! OnboardingCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    
}

//MARK:- UIScrollView Deleagte
extension OnboardingViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int( collectionView.contentOffset.x / collectionView.frame.size.width)
    }
}
