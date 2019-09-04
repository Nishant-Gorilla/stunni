//
//  JobsViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 13/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class JobsViewController: BaseViewController {

    var jobViewModel: JobViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        jobViewModel = JobViewModel(delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showJobDeailView" {
            if let vc = segue.destination as? JobsDetailViewController {
                let row = (sender as! UITableViewCell).tag
                vc.job = jobViewModel.getJob(at: row)
            }
        }
    }
    
}

//MARK:- UITableViewDelegate
extension JobsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobViewModel.numberOfJobs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobTableViewCell") as! JobTableViewCell
        cell.tag = indexPath.row
        cell.set(job: jobViewModel.getJob(at: indexPath.row))
        return cell
    }
}

//MARK:- ViewModel Delegate
extension JobsViewController: JobViewModelDelegate {
    func reloadData() {
        tableView.reloadData()
        hideLoader()
    }
    
    func didReceive(error: Error) {
        hideLoader()
        showAlertWith(title: "Error!", message: error.localizedDescription)
    }
}
