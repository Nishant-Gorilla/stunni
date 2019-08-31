//
//  JobsDetailViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 13/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class JobsDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


//MARK:- UITableViewDataSource
extension JobsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        return cell
    }
}
