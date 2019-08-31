//
//  JobsViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 13/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class JobsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK:- UITableViewDelegate
extension JobsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        return cell
    }
}
