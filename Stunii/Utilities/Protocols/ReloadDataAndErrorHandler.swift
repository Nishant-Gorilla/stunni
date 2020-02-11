//
//  ReloadDataAndErrorHandler.swift
//  Stunii
//
//  Created by inderjeet on 29/08/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import Foundation
protocol ReloadDataAndErrorHandler: class {
    func reloadData()
    func didReceive(error: Error)
}


