//
//  BaseViewController.swift
//  
//
//  Created by Uday Bhateja on 23/06/19.
//

import UIKit
import RSLoadingView

class BaseViewController: UIViewController {
    
    private let loader = RSLoadingView(effectType: .spinAlone)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoader() {
        DispatchQueue.main.async {
            self.loader.showOnKeyWindow()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            RSLoadingView.hideFromKeyWindow()
        }
    }
}
