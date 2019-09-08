//
//  Extensions.swift
//  Stunii
//
//  Created by Uday Bhateja on 23/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

//MARK:- UIViewController
extension UIViewController {
    func showAlertWith(title: String?, message: String?, buttonTitle: String? = nil,
                       clickHandler: (()->())? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        if let _title = buttonTitle {
            let action = UIAlertAction(title: _title, style: .default, handler: { (_) in
                clickHandler?()
            })
            alertController.addAction(cancelAction)
            alertController.addAction(action)

            alertController.preferredAction = action
        }
        else {
            alertController.addAction(okAction)
        }
        
        present(alertController, animated: true, completion: nil)
    }
}



//MARK:- UIView
extension UIView {
    
    @IBInspectable var circular: Bool {
        get {return self.circular}
        set {layer.cornerRadius = frame.size.height/2.0}
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {return layer.cornerRadius}
        set {layer.cornerRadius = newValue}
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {return UIColor(cgColor: layer.borderColor!)}
        set {layer.borderColor = newValue?.cgColor}
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {return UIColor(cgColor: layer.shadowColor!)}
        set {layer.shadowColor = newValue?.cgColor}
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {return layer.shadowOffset}
        set {layer.shadowOffset = newValue}
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {return layer.shadowRadius}
        set {layer.shadowRadius = newValue}
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {return layer.shadowOpacity}
        set {layer.shadowOpacity = newValue}
    }
    
}

//MARK:- UIColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}

extension SkyFloatingLabelTextField {
    func setTitle(size: CGFloat) {
        
        //Done to return the title as placeholder not in uppercase
        titleFormatter = { _text in
            return _text
        }
        titleFont = StuniiFont.regular(size: size)
    }
}

extension String {
    func trimSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
}
