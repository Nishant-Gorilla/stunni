//
//  DemandViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 25/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class DemandViewController: BaseViewController {

    @IBOutlet weak var cityTextField            : SkyFloatingLabelTextField!
    @IBOutlet weak var organisationTextField    : SkyFloatingLabelTextField!
    @IBOutlet weak var dealTypeField            : SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldTitleFormatter()
    }
    
    private func setTextFieldTitleFormatter() {
        cityTextField.titleFormatter = {text in
            return text}
        organisationTextField.titleFormatter = {text in
            return text}
        dealTypeField.titleFormatter = {text in
            return text}
    }

}
