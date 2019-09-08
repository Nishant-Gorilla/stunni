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
    
    func validateTextFields() -> Bool  {
        if isAnyTextFieldEmpty() {
            let message = "Please fill empty fields"
            showAlertWith(title: nil, message: message)
            return false
        }
        return true
    }
    let paramater :[String: Any] = [
        "city":"test",
        "organisation":"test",
        "dealType":"test",
        "studentId":"1234"
    ]
    
    
    private func isAnyTextFieldEmpty() -> Bool {
        return cityTextField.text!.trimSpace() == "" ||
            organisationTextField.text!.trimSpace() == "" ||
            dealTypeField.text!.trimSpace() == ""
    }
    
    @IBAction func demandButtonAction(sender: UIButton) {
        if validateTextFields() {
            showLoader()
            let paramater :[String: Any] = [
                "city":cityTextField.text!.trimSpace(),
                "organisation":organisationTextField.text!.trimSpace(),
                "dealType":dealTypeField.text!.trimSpace(),
                "studentId":UserData.loggedInUser?._id ?? ""
            ]
            APIHelper().postDemand(parameters: paramater) {[weak self] (dict, error) in
                self?.hideLoader()
                if error == nil {
                    let status = dict?["status"] as? Int ?? 0
                    let message = dict?["message"] as? String ?? ""
                    let alertTitle = status == 200 ? "Success" : "Failed"
                    self?.showAlertWith(title: alertTitle, message: message)
                } else {
                    self?.showAlertWith(title: "Failed", message: "Something went wrong please try again latter")
                }
            }
        }
    }
}
    
