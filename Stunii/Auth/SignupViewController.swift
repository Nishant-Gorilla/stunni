//
//  SignupViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 25/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpFields: NSObject {
    @objc dynamic var firstName         : String?
    @objc dynamic var lastName          : String?
    @objc dynamic var dob               : String?
    @objc dynamic var eduEmail          : String?
    @objc dynamic var personalEmail     : String?
    @objc dynamic var phone             : String?
    @objc dynamic var institute         : String?
    @objc dynamic var course            : String?
    @objc dynamic var graduationDate    : String?
    @objc dynamic var password          : String?
    @objc dynamic var subscription      : String?
    @objc dynamic var gender            : String?
    @objc dynamic var vegan             : String?
    @objc dynamic var nightOut          : String?
    @objc dynamic var hobby             : String?
    
    let fieldsKeys: [[String]] = [
        ["firstName", "lastName", "dob"],
        ["eduEmail", "personalEmail", "phone"],
        ["institute", "course", "graduationDate"],
        ["password", "subscription"], ["gender"], ["vegan"],
        ["nightOut"], ["hobby"]
    ]
}


class SignupViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var optionsView          : UIView!
    @IBOutlet weak var textFieldStack       : UIStackView!
    @IBOutlet weak var optionLabel          : UILabel!
    @IBOutlet weak var bgImageView          : UIImageView!
    @IBOutlet weak var scratchImageView     : UIImageView!
    @IBOutlet weak var progressImageView    : UIImageView!
    @IBOutlet weak var backButton           : UIButton!
    @IBOutlet weak var optionsWelcome       : UIView!
    @IBOutlet weak var mainStackView        : UIStackView!
    
    @IBOutlet weak var optionsWithThree     : UIView!
    @IBOutlet var options3TitleLabel        : [UILabel]!
    @IBOutlet var options3Image             : [UIImageView]!
    @IBOutlet var options3View              : [UIView]!
    
    @IBOutlet var optionsWithFour           : UIView!
    @IBOutlet var options4TitleLabel        : [UILabel]!
    @IBOutlet var options4Image             : [UIImageView]!
    @IBOutlet var options4View              : [UIView]!
    
    
    
    @IBOutlet weak var passwordView         : UIView!
    @IBOutlet weak var passwordTextField    : SkyFloatingLabelTextField!
    @IBOutlet weak var passwordEyeImageView : UIImageView!
    @IBOutlet weak var tncSwitch            : UISwitch!
    @IBOutlet var subscriptionViews         : [UIView]!
    
    @IBOutlet var textFields                : [SkyFloatingLabelTextField]!
    
    //MARK: Variable & Constants
    
    private var currentPageIndex    : Int = 0
    private let MAX_PAGES           : Int = 8
    private let textPagesCount      : Int = 3
    private let PASSWORD_INDEX      : Int = 3
    private let option3StartIndex   : Int = 4
    private let option3EndIndex     : Int = 6
    private var selectedOptionIndex : Int?
    
    private let homeSegue   = "segue_home"
    private let fields      = SignUpFields()
    private let uiModel     = SignUpUIModel().get()
    
    private let datePicker          : UIDatePicker = UIDatePicker()
    private let dataPicker          : UIPickerView =
        UIPickerView()

    //MARK:-View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
        let dateForm = DateFormatter()
        dateForm.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        let ds = dateForm.string(from: Date())
        print(ds)
    }
    
    //MARK: IBActions
    @IBAction func nextButtonClicked(_ sender: Any) {
        guard saveDataFor(page: currentPageIndex) else {return}
        currentPageIndex += 1
        updateCurrentPage()
    }
    
    @IBAction func backButtonClicked(_sender: Any) {
        guard currentPageIndex != 0 else {
            navigationController?.popViewController(animated: true)
            return
        }
        currentPageIndex -= 1
        updateCurrentPage()
        setData()
    }
    
    @IBAction func option3Tapped(_ sender: UIButton) {
        options3View.forEach({$0.borderColor = .clear})
        options3View[sender.tag].borderColor = StuniiColor.orange
        selectedOptionIndex = sender.tag
    }
    
    @IBAction func option4Tapped(_ sender: UIButton) {
        options4View.forEach({$0.borderColor = .clear})
        options4View[sender.tag].borderColor = StuniiColor.orange
        selectedOptionIndex = sender.tag
    }
    
    @IBAction func subscriptionButtonTapped(_ sender: UIButton) {
        subscriptionViews.forEach({$0.backgroundColor = .clear})
        subscriptionViews[sender.tag].backgroundColor = StuniiColor.orange
        selectedOptionIndex = sender.tag
    }
    
    @IBAction func lastTextFieldEditingEnd(_ sender: Any) {
        if currentPageIndex == 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateString = dateFormatter.string(from: datePicker.date)
            textFields.last!.text = dateString
        }
    }
    
    @IBAction func passwordEyeButtonTapped(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        passwordEyeImageView.image = passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "eye-close") : #imageLiteral(resourceName: "eye-open")
    }
    
    @IBAction func textFieldDidBeginEditing(_ sender: SkyFloatingLabelTextField) {
        if currentPageIndex == 2 &&
            sender == textFields.first! {
            let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchTVVC") as! SearchTableViewViewController
            present(searchVC, animated: false, completion: nil)
            searchVC.selectionBlock = { value in
                sender.text = value
            }
        }else if currentPageIndex == 2 && sender == textFields[1] {
            let searchVC = storyboard?.instantiateViewController(withIdentifier: "SearchTVVC") as! SearchTableViewViewController
            searchVC.isSchool = false
            present(searchVC, animated: false, completion: nil)
            searchVC.selectionBlock = { value in
                sender.text = value
            }
            }
        return
        }
    
    
    @IBAction func unwindToSignup(sender: UIStoryboardSegue) {
        
    }
    
    //MARK: Private Functions
    
    private func initialize() {
        setTextFieldTitleFont()
        mainStackView.addArrangedSubview(passwordView)
        
        passwordView.isHidden   = true
        textFieldStack.isHidden = false
        optionsView.isHidden    = true
        
        tncSwitch.transform     = CGAffineTransform(
            scaleX: 0.75,y: 0.75)
        
        setDatePickerView()
        setDataPicker()
        textFields.last!.inputView = datePicker
    }
    
    private func resetOptionsBorderColor() {
        options3View.forEach({$0.borderColor = .clear})
        options4View.forEach({$0.borderColor = .clear})
    }
    
    private func saveDataFor(page: Int) -> Bool {
        if page < textPagesCount {
            let keys = fields.fieldsKeys[page]
            for i in 0 ..< keys.count {
                let value = textFields[i].text
                let key = keys[i]
                let error = SignUpUIModel.validate(value: value, key: key)
                if let  error = error {
                    showAlertWith(title: nil, message: error)
                    return false
                }
                fields.setValue(value?.trimSpace(), forKey: key)
            }
        }
        else if page == PASSWORD_INDEX {
            let keys = fields.fieldsKeys[page]
            let error = SignUpUIModel.validate(value: passwordTextField.text!, key: keys[0])
            if let  error = error {
                showAlertWith(title: nil, message: error)
                return false
            }
            fields.setValue(passwordTextField.text!, forKey: keys[0])
            if !tncSwitch.isOn {
                showAlertWith(title: nil, message: "Please accept terms and conditions")
                return false
            }
            
            if let selected = selectedOptionIndex {
                fields.setValue(String(selected), forKey: keys[1])
                selectedOptionIndex = nil
            } else {
                showAlertWith(title: nil, message: "Please choose an option for subscription")
                return false
            }
        }
        else {
            guard let selectedIndex = selectedOptionIndex else {
                    showAlertWith(title: nil, message: "Please choose an option")
                return false
            }
            let key = fields.fieldsKeys[page]
            let selectedValue = uiModel[page].titles[selectedIndex]
            fields.setValue(selectedValue, forKey: key[0])
        }
        selectedOptionIndex = nil
        return true
    }
    
    private func updateCurrentPage() {
        if currentPageIndex < textPagesCount {
            textFields.forEach({
                $0.text = ""
                $0.placeholder = uiModel[currentPageIndex].titles[$0.tag]
                $0.keyboardType = uiModel[currentPageIndex].keyboardType[$0.tag]
            })
            
            textFields.last!.inputView = nil
            if currentPageIndex == 0 {
                textFields.last!.inputView = datePicker
            }
            else if currentPageIndex == 2 {
                textFields.last!.inputView = dataPicker
            }
            
            textFieldStack.isHidden = false
            passwordView.isHidden   = true
            optionsView.isHidden    = true
            
            bgImageView.image
                = uiModel[currentPageIndex].bgImage
            scratchImageView.image
                = uiModel[currentPageIndex].scratchImage
            progressImageView.image
                = uiModel[currentPageIndex].progressImage
        }
        else if currentPageIndex == PASSWORD_INDEX {
            optionsWithThree.isHidden   = true
            optionsWelcome.isHidden     = true
            optionsView.isHidden        = true
            textFieldStack.isHidden     = false
            passwordView.isHidden       = false
            passwordView.frame = CGRect(x: 0, y: 0, width: 100.0, height: 200.0)
            textFieldStack.isHidden     = true
            
            passwordTextField.text = ""
            
            bgImageView.image
                = uiModel[currentPageIndex].bgImage
            scratchImageView.image
                = uiModel[currentPageIndex].scratchImage
            progressImageView.image
                = uiModel[currentPageIndex].progressImage
        }
        else if currentPageIndex < option3EndIndex {
            optionsWithThree.isHidden   = false
            optionsView.isHidden        = false
            optionsWithFour.isHidden    = true
            textFieldStack.isHidden     = true
            passwordView.isHidden       = true
            
            optionsWelcome.isHidden =
                currentPageIndex != option3StartIndex
            optionLabel.text = uiModel[currentPageIndex].optionsHeading
            
            let titleArray = uiModel[currentPageIndex].titles
            let images = uiModel[currentPageIndex].images
            for i in 0 ..< options3Image.count {
                options3Image[i].image = images[i]
                options3TitleLabel[i].text = titleArray[i]
            }
            
            resetOptionsBorderColor()
            
            bgImageView.image = uiModel[currentPageIndex].bgImage
            scratchImageView.image = uiModel[currentPageIndex].scratchImage
            progressImageView.image = uiModel[currentPageIndex].progressImage
            
            backButton.isHidden = (currentPageIndex == 0)
        }
            
        else if currentPageIndex < MAX_PAGES {
            optionsWithThree.isHidden = true
            optionsWithFour.isHidden = false
            textFieldStack.isHidden = true
            optionsView.isHidden = false
            optionLabel.text = uiModel[currentPageIndex].optionsHeading
            
            let titleArray = uiModel[currentPageIndex].titles
            let images = uiModel[currentPageIndex].images
            for i in 0 ..< options4Image.count {
                options4Image[i].image = images[i]
                options4TitleLabel[i].text = titleArray[i]
            }
            
            resetOptionsBorderColor()
            
            bgImageView.image = uiModel[currentPageIndex].bgImage
            scratchImageView.image = uiModel[currentPageIndex].scratchImage
            progressImageView.image = uiModel[currentPageIndex].progressImage
        }
        else {
            // Call Sign up api here
            showLoader()
            SignUpUIModel.signUp(fields: fields) { [weak self] (error) in
                DispatchQueue.main.async {
                    self?.hideLoader()
                }
                guard let error = error else {
                    guard let _self = self else { return }
                    DispatchQueue.main.async {
                    _self.performSegue(withIdentifier: _self.homeSegue, sender: nil)
                    }
                    return
                }
                DispatchQueue.main.async {
                self?.showAlertWith(title: nil, message: error)
                }
            }
            
           
        }
    }
    
    func setData() {
        if currentPageIndex < textFields.count {
            let keys = fields.fieldsKeys[currentPageIndex]
            for i in 0 ..< textFields.count {
                let value = fields.value(forKey: keys[i]) as? String
                textFields[i].text = value
            }
        }
        else if currentPageIndex == PASSWORD_INDEX {
            let keys = fields.fieldsKeys[currentPageIndex]
            passwordTextField.text = fields.value(forKey: keys[0]) as? String
            if let viewTag = fields.subscription {
                if let intTag = Int(viewTag) {
                subscriptionViews[intTag].backgroundColor = StuniiColor.orange
                    selectedOptionIndex = intTag
                }
            }
        }
        else if currentPageIndex < option3EndIndex {
            let key = fields.fieldsKeys[currentPageIndex]
            if let value = fields.value(forKey: key[0]) as? String,
                let selectedIndex = uiModel[currentPageIndex].titles
                    .firstIndex(of: value) {
                options3View[Int(selectedIndex)].borderColor = StuniiColor.orange
                selectedOptionIndex = selectedIndex
            }
        }
        else if currentPageIndex < MAX_PAGES {
            let key = fields.fieldsKeys[currentPageIndex]
            if let value = fields.value(forKey: key[0]) as? String,
                let selectedIndex = uiModel[currentPageIndex].titles
                    .firstIndex(of: value) {
                options4View[Int(selectedIndex)].borderColor = StuniiColor.orange
            }
        }
    }
    
    private func setTextFieldTitleFont() {
        let titleSize: CGFloat = 17.0
        textFields.forEach({
            $0.setTitle(size: titleSize)
        })
        passwordTextField.setTitle(size: titleSize)
    }
    
    private func setDatePickerView() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.backgroundColor = StuniiColor.orange
    }
    
    private func setDataPicker() {
        dataPicker.dataSource   = self
        dataPicker.delegate     = self
    }
}


extension SignupViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let year = Calendar.current.component(.year, from: Date()) + row
        return "\(year)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           let year = Calendar.current.component(.year, from: Date()) + row
        textFields.last!.text = "\(year)"
    }
}
