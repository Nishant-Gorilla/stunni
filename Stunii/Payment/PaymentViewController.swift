//
//  PaymentViewController.swift
//  Stunii
//
//  Created by Admin on 08/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController {

    @IBOutlet weak var textField_cardNo: UITextField!
    @IBOutlet weak var textField_year: UITextField!
    @IBOutlet weak var textField_cvv: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func paymentButtonAction(_ sender: Any) {
        let cardParams = STPCardParams()
        cardParams.number = textField_cardNo.text!
        cardParams.expMonth = 12
        cardParams.expYear = 2022
        cardParams.cvc = textField_cvv.text!
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if let err = error {
                showAlertWith(title: "Error", message: err.localizedDescription)
            }
            else if let to {
                
            }
        }
    }
   

}
