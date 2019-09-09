//
//  JobsDetailViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 13/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import MessageUI
import Kingfisher
class JobsDetailViewController: BaseViewController {
    var jobDetailViewModel:JobDeailViewModel!
    var job: Job!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var jobTypeLabel: UILabel!
    @IBOutlet weak var jobRateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyImageView: UIImageView!
    
    @IBOutlet weak var applyButton: UIButton!
    var isLoadingData = true
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.hideExtraRows()
        showLoader()
        jobDetailViewModel = JobDeailViewModel(jobId:job.id ?? "", delegate: self)
    }
    
    private func setData() {
        guard let job = jobDetailViewModel.getJob() else { return }
        jobTitleLabel.text = job.jobName
        companyNameLabel.text = job.companyName
        addressLabel.text = job.jobAddress
        jobTypeLabel.text = job.jobType
        jobRateLabel.text = job.jobRate
        
        companyImageView.kf.indicatorType = .activity
        companyImageView.kf.setImage(with: URL(string:job.companyImage ?? ""))
    }
    
    
   private func showSendMail() {
    if MFMailComposeViewController.canSendMail() {
        let toRecipents = [jobDetailViewModel.getJobMail()]
        let cc = ["jobs@stunii.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject("")
        mc.setMessageBody("", isHTML: false)
        mc.setToRecipients(toRecipents)
        mc.setCcRecipients(cc)
        self.present(mc, animated: true, completion: nil)
    } else {
        showAlertWith(title: nil, message: "This device not able to send email")
    }
    }
    
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        showSendMail()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


//MARK:- UITableViewDataSource
extension JobsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoadingData ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobDetailTableViewCell") as! JobDetailTableViewCell
        cell.jobDetailLabel.text = jobDetailViewModel.getJobDetail()
        return cell
    }
}

//MARK:- ViewModel Delegate
extension JobsDetailViewController: JobDetailViewModelDelegate {
    func reloadData() {
        isLoadingData = false
        DispatchQueue.main.async {
            self.setData()
            self.tableView.reloadData()
            self.hideLoader()
        }
        
    }
    
    func didReceive(error: Error) {
        isLoadingData = false
        hideLoader()
        showAlertWith(title: "Error!", message: error.localizedDescription)
    }
}

extension JobsDetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
}
