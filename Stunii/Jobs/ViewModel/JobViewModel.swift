//
//  JobViewModel.swift
//  Stunii
//
//  Created by inderjeet on 04/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
class JobViewModel: NSObject {
    var delegate: JobViewModelDelegate?
    private var jobs: [Job] = [] {
        didSet {
            delegate?.reloadData()
        }
    }
    
    var numberOfJobs: Int  {
        return jobs.count
    }
    
    
    init(delegate: JobViewModelDelegate) {
        super.init()
        self.delegate = delegate
        getData()
    }
    
    private func getData() {
        APIHelper.getAllJobs{ [weak self] (data, error) in
            if let err = error {
                self?.delegate?.didReceive(error: err)
            }
            else if let jobs = data {
                self?.jobs = jobs
            }
        }
    }
    
    func getJob(at index: Int) -> Job {
        return jobs[index]
    }
    
}

protocol JobViewModelDelegate: ReloadDataAndErrorHandler { }
