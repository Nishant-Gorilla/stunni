//
//  JobDetailViewModel.swift
//  Stunii
//
//  Created by inderjeet on 04/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
import MessageUI
import UIKit
class JobDeailViewModel: NSObject {
    var delegate: JobDetailViewModelDelegate?
    var jobId:String!
    private var job: Job? {
        didSet {
            delegate?.reloadData()
        }
    }
    
    init(jobId:String, delegate: JobDetailViewModelDelegate) {
        super.init()
        self.delegate = delegate
        self.jobId = jobId
        getData()
    }
    func getJob() -> Job? {
        return job
    }
    
    
    private func getData() {
        APIHelper().getJobDetail(jobId: jobId){ [weak self] (data, error) in
            if let err = error {
                self?.delegate?.didReceive(error: err)
            }
            else if let job = data {
                self?.job = job
            }
        }
    }
    func getJobMail() -> String {
        return job?.companyEmail ?? ""
    }
    
    func getJobDetail() -> String {
        return job?.jobDescription ?? ""
    }
    
    }

protocol JobDetailViewModelDelegate: ReloadDataAndErrorHandler { }

