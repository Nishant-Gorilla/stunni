//
//  LoginViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 01/07/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController:BaseViewController {

    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var eyeImageView: UIImageView!
    @IBOutlet weak var owlImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
       showLoader()
       APIHelper.login(email: emailTextField.text!,
                        password: passwordTextField.text!) {[ weak self ] (user, error) in
                            
                            self?.hideLoader()
                            if error == nil && user != nil {
                                APIHelper.isVipUser(userId: user!._id, completion: { (isVip, error) in
                                    user!.isVIP = false//isVip
                                    UserData.loggedInUser = user!
                                    MainScreenUtility.setHomeAsRoot()
                                })
                            } else {
                                DispatchQueue.main.async {
                                self?.showAlertWith(title: nil, message: error?.localizedDescription ?? "Login failed!")
                                }
                            }
        }

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


extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
