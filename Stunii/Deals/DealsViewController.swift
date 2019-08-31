//
//  DealsViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 27/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class DealsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var tvCellFactory: DealsTVCellFactory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvCellFactory = DealsTVCellFactory(tblView: tableView)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK:- TableView Datasource
extension DealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tvCellFactory.cellForRowAt(indexPath: indexPath)
    }
}

extension DealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 75.0
        }
        return UITableView.automaticDimension
    }
}
