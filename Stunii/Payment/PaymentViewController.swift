//
//  PaymentViewController.swift
//  Stunii
//
//  Created by Admin on 08/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var textField_cardNo: UITextField!
    @IBOutlet weak var textField_year: UITextField!
    @IBOutlet weak var textField_cvv: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var price: String = "\(POUNDS_STRING) 9.99"
    
    private var datePicker: DatePickerView!
    private var stripeToken: String? {
        didSet {
           hitStripeAPI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = DatePickerView()
        textField_year.inputView = datePicker
        textField_year.delegate = self
        
        priceLabel.text = "ANNUAL DEAL PACKAGE \(price) YEARLY"
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func paymentButtonAction(_ sender: Any) {
        
        guard validate() else {
            showAlertWith(title: "Error!", message: "Please enter all card details.")
            return}
        
        showLoader()
        
        
        let calendar = Calendar.current
        let cardParams = STPCardParams()
        cardParams.number = textField_cardNo.text!
        cardParams.expMonth = UInt(calendar.component(.month, from: datePicker.date))
        cardParams.expYear = UInt(calendar.component(.year, from: datePicker.date))
        cardParams.cvc = textField_cvv.text!
        
        STPAPIClient.shared().createToken(withCard: cardParams) {
            [weak self] (token, error) in
            if let err = error {
                self?.hideLoader()
                self?.showAlertWith(title: "Error", message: err.localizedDescription)
            }
            else if let _token = token {
                self?.stripeToken = _token.tokenId
            }
        }
    }
    
    private func hitStripeAPI() {
        APIHelper.sendStripeToken(stripeToken!, completion: {
            [weak self] (success, errorMessage) in
            self?.hideLoader()
            if success {
                UserData.loggedInUser?.isVIP = true
                let alert = UIAlertController(title: "Success", message: errorMessage ?? "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    MainScreenUtility.setHomeAsRoot()
                }))
                self?.present(alert, animated: true, completion: nil)
            }
            else if let msg = errorMessage {
                self?.showAlertWith(title: "Error!", message: msg)
            }
        })
    }
   
    
    private func validate() -> Bool {
        if (textField_cardNo.text?.isEmpty)! || (textField_year.text?.isEmpty)! || (textField_cvv.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let calendar = Calendar.current
        let month = UInt(calendar.component(.month, from: datePicker.date))
        let year = UInt(calendar.component(.year, from: datePicker.date))
        textField.text = "\(month)-\(year)"
    }

}















enum DatePickerComponent : Int
{
    case month, year
}

class DatePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource
{
    fileprivate let bigRowCount = 1000
    fileprivate let componentsCount = 2
    var minYear = 2019
    var maxYear = 2031
    var rowHeight : CGFloat = 44
    
    var monthFont = UIFont.boldSystemFont(ofSize: 17)
    var monthSelectedFont = UIFont.boldSystemFont(ofSize: 17)
    
    var yearFont = UIFont.boldSystemFont(ofSize: 17)
    var yearSelectedFont = UIFont.boldSystemFont(ofSize: 17)
    
    var monthTextColor = UIColor.black
    var monthSelectedTextColor = UIColor.blue
    
    var yearTextColor = UIColor.black
    var yearSelectedTextColor = UIColor.blue
    
    fileprivate let formatter = DateFormatter.init()
    
    fileprivate var rowLabel : UILabel
    {
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: componentWidth, height: rowHeight))
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }
    
    var months : Array<String>
    {
        return [NSLocalizedString("January", comment: ""), NSLocalizedString("February", comment: ""), NSLocalizedString("March", comment: ""), NSLocalizedString("April", comment: ""), NSLocalizedString("May", comment: ""), NSLocalizedString("June", comment: ""), NSLocalizedString("July", comment: ""), NSLocalizedString("August", comment: ""), NSLocalizedString("September", comment: ""), NSLocalizedString("October", comment: ""), NSLocalizedString("November", comment: ""), NSLocalizedString("December", comment: "")]
    }
    
    var years : Array<String>
    {
        let years = [Int](minYear...maxYear)
        var names = [String]()
        for year in years
        {
            names.append(String(year))
        }
        return names
    }
    
    var currentMonthName : String
    {
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.dateFormat = "MMMM"
        let dateString = formatter.string(from: Date.init())
        return NSLocalizedString(dateString, comment: "")
    }
    
    var currentYearName : String
    {
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.dateFormat = "yyyy"
        return formatter.string(from: Date.init())
    }
    
    fileprivate var bigRowMonthCount : Int
    {
        return months.count  * bigRowCount
    }
    
    fileprivate var bigRowYearCount : Int
    {
        return years.count  * bigRowCount
    }
    
    fileprivate var componentWidth : CGFloat
    {
        return self.bounds.size.width / CGFloat(componentsCount)
    }
    
    fileprivate var todayIndexPath : IndexPath
    {
        var row = 0
        var section = 0
        let currentMonthName = self.currentMonthName
        let currentYearName = self.currentYearName
        
        for month in months
        {
            if month == currentMonthName
            {
                row = months.index(of: month)!
                row += bigRowMonthCount / 2
                break;
            }
        }
        
        for year in years
        {
            if year == currentYearName
            {
                section = years.index(of: year)!
                section += bigRowYearCount / 2
                break;
            }
        }
        return IndexPath.init(row: row, section: section)
    }
    
    var date : Date
    {
        let month = months[selectedRow(inComponent: DatePickerComponent.month.rawValue) % months.count]
        let year = years[selectedRow(inComponent: DatePickerComponent.year.rawValue) % years.count]
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "MMMM:yyyy"
        let date = formatter.date(from: "\(month):\(year)")
        return date!
    }
    
    //MARK: - Override
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        loadDefaultsParameters()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        loadDefaultsParameters()
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        loadDefaultsParameters()
    }
    
    //MARK: - Open
    func selectToday()
    {
        selectRow((todayIndexPath as NSIndexPath).row, inComponent: DatePickerComponent.month.rawValue, animated: false)
        selectRow((todayIndexPath as NSIndexPath).section, inComponent: DatePickerComponent.year.rawValue, animated: false)
    }
    
    //MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return componentWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let label : UILabel
        if view is UILabel
        {
            label = view as! UILabel
        }
        else
        {
            label = rowLabel
        }
        
        let selected = isSelectedRow(row, component: component)
        label.font = selected ? selectedFontForComponent(component) : fontForComponent(component)
        label.textColor = selected ? selectedColorForComponent(component) : colorForComponent(component)
        label.text = titleForRow(row, component: component)
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return rowHeight
    }
    
    //MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return componentsCount
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if component == DatePickerComponent.month.rawValue
        {
            return bigRowMonthCount
        }
        return bigRowYearCount
    }
    
    //MARK: - Private
    
    fileprivate func loadDefaultsParameters()
    {
        delegate = self
        dataSource = self
    }
    
    fileprivate func isSelectedRow(_ row : Int, component : Int) -> Bool
    {
        var selected = false
        if component == DatePickerComponent.month.rawValue
        {
            let name = months[row % months.count]
            if name == currentMonthName
            {
                selected = true
            }
        }
        else
        {
            let name = years[row % years.count]
            if name == currentYearName
            {
                selected = true
            }
        }
        
        return selected
    }
    
    fileprivate func selectedColorForComponent(_ component : Int) -> UIColor
    {
        if component == DatePickerComponent.month.rawValue
        {
            return monthSelectedTextColor
        }
        return yearSelectedTextColor
    }
    
    fileprivate func colorForComponent(_ component : Int) -> UIColor
    {
        if component == DatePickerComponent.month.rawValue
        {
            return monthTextColor
        }
        return yearTextColor
    }
    
    fileprivate func selectedFontForComponent(_ component : Int) -> UIFont
    {
        if component == DatePickerComponent.month.rawValue
        {
            return monthSelectedFont
        }
        return yearSelectedFont
    }
    
    fileprivate func fontForComponent(_ component : Int) -> UIFont
    {
        if component == DatePickerComponent.month.rawValue
        {
            return monthFont
        }
        return yearFont
    }
    
    fileprivate func titleForRow(_ row : Int, component : Int) -> String
    {
        if component == DatePickerComponent.month.rawValue
        {
            return months[row % months.count]
        }
        return years[row % years.count]
    }
}
