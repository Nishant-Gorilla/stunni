//
//  ForgotPasswordViewController.swift
//  Stunii
//
//  Created by Admin on 10/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordViewController: BaseViewController {
    
  
    @IBOutlet weak var textFieldEmail: SkyFloatingLabelTextField!
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func resetButtonAction(_ sender: Any) {
        if let msg = FormValidator.checkValidEmail(textFieldEmail.text) {
            showAlertWith(title: "Error!", message: msg)
        }
        else {
            showLoader()
            APIHelper.forgotPassword(email: textFieldEmail.text!, completion: {
                (success, errorMsg) in
                self.hideLoader()
                DispatchQueue.main.async {
                    self.showAlertWith(title: errorMsg, message: nil)
                }
                
            })
        }
    }
}
