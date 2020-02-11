//
//  ReferralViewController.swift
//  Stunii
//
//  Created by Ajay Kumar on 20/10/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class ReferralViewController: BaseViewController {

    @IBOutlet weak var textFieldReferral: UITextField!
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    //MARK:- Properties
       private var referralViewModel: ReferralViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showLoader()
        referralViewModel = ReferralViewModel(delegate: self)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtnClicked(_ sender: UIButton) {
           MainScreenUtility.setHomeAsRoot()
       }
    
    
    @IBAction func SkipTestBtnClicked(_ sender: UIButton) {
        MainScreenUtility.setHomeAsRoot()
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        if(textFieldReferral.text == ""){
             showAlertWith(title:"Alert", message: "Please select referral first")
        }else{
            showLoader()
            submitData()
        }
    }
    
    @IBAction func dropDownBtnClicked(_ sender: UIButton) {
               OpenPicker()
             }
       
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ReferralViewController {
    
    func OpenPicker(){
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }


    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func submitData(){
        APIHelper.submitReferral(textFieldReferral.text ?? "") { (status, str) -> (()) in
            self.hideLoader()
            let alert = UIAlertController(title: "Success", message:"Thank you", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    MainScreenUtility.setHomeAsRoot()
                }))
            self.present(alert, animated: true, completion: nil)

        }
    }
    
}//&fullname=test&email=abc@gmail.com&referBy=stunii&university=xyz


extension ReferralViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return referralViewModel.numberOfRows
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       // print(YOUR_DATA_ARRAY[row])
        return referralViewModel.model[row].referralfrom
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldReferral.text = referralViewModel.model[row].referralfrom
    }
}

//MARK:- ViewModel Delegate

extension ReferralViewController: ReferralVMDelegate {

    func reloadData() {
        picker.reloadAllComponents()
        hideLoader()
    }
    
    func didReceive(error: Error) {
        hideLoader()
        showAlertWith(title: "Error!", message: error.localizedDescription)
    }
}
