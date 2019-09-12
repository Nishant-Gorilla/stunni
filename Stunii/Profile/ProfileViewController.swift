//
//  ProfileViewController.swift
//  Stunii
//
//  Created by inderjeet on 02/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import SDWebImage
struct StuId {
    
    init(date: String, graduationDate: String) {
        _createdAt = date
        self.graduationDate = graduationDate
        setFormat()
    }
    
    var _createdAt: String?
    var graduationDate: String?
    var verifiedUntil: String?
    var photo: String?
    
    mutating func setFormat() {
            verifiedUntil = graduationDate
        }
}

class ProfileViewController: BaseViewController {
    typealias doneActionClouser = () -> ()
    var actionClouser: doneActionClouser?
    
    @IBOutlet var imgViewVerified: UIImageView!
    @IBOutlet weak var coverPicImageView: UIImageView!
    @IBOutlet weak var verifiedUntilLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var universityNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var willPop: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        
        APIHelper.stuId(completion: {
            data in
            DispatchQueue.main.async {
                self.verifiedUntilLabel.text = "Verfied until: " + (data?.verifiedUntil ?? "")
                if let _photo = data?.photo {
                    let url = WebServicesURL.ImagesBase.students + UserData.loggedInUser!._id + "/o/" + _photo
                    //self.setImage(url: url)
                }
            }
        })
    }
    
    func setImage(url: String) {
        guard let _url = URL(string: url) else {return}
        userProfileImageView.sd_setImage(with: _url, completed: nil)
    }
    
    func setData() {
        guard let user = UserData.loggedInUser else { return }
        let name = (user.fname ?? "") + " " + (user.lname ?? "")
        userNameLabel.text = name
        universityNameLabel.text = user.institution ?? ""
        userProfileImageView.image = #imageLiteral(resourceName: "app_icon")
        
        imgViewVerified.image = imgViewVerified.image!.withRenderingMode(.alwaysTemplate)
        imgViewVerified.tintColor = .white
        
        if willPop {
            backButton.isHidden = false
            doneButton.isHidden = false
        }
    }

    @IBAction func imageTapped(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.sourceType = .photoLibrary
        present(imageController, animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        actionClouser?()
        navigationController?.popViewController(animated: true)
    }
    
}


extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            showLoader()
            APIManager.shared.multipart(image: image, completion: { success in
                self.hideLoader()
                if let _success = success, _success == true {
                    DispatchQueue.main.async {
                        self.userProfileImageView.image = image
                    }
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


