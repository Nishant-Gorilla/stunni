//
//  LoginViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 01/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var eyeImageView: UIImageView!
    @IBOutlet weak var owlImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        MainScreenUtility.setHomeAsRoot()
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func passwordEyeButtonTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        eyeImageView.image = passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "eye-close") : #imageLiteral(resourceName: "eye-open")
    }
    
    @IBAction func backButtonTapped(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            owlImageView.image = #imageLiteral(resourceName: "owl-open")
        }
        else if textField == passwordTextField {
            owlImageView.image = #imageLiteral(resourceName: "owl-close")
        }
    }
}
