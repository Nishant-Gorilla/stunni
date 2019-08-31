//
//  TestViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 30/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var lastView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCli(_ sender: Any) {
        lastView.isHidden = !lastView.isHidden
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
