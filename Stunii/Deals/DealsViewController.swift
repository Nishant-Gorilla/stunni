//
//  DealsViewController.swift
//  Stunii
//
//  Created by Zap.Danish on 27/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher
import MessageUI

class DealsViewController: BaseViewController {
    var dealsViewModel: DealsViewModel?

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var redeeamBtn: UIButton!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var ratingStarImageVIew: UIImageView!
    @IBOutlet weak var everyDayLabel: UILabel!
    @IBOutlet weak var providerImageView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var tvCellFactory: DealsTVCellFactory!
    var deal: Deal?
    var isLoading = true
    var contactNo = String()
    var appLink = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
             self.showLoader()
            self.dealsViewModel = DealsViewModel(dealId:self.deal?.id ?? "", delegate: self)
            self.tvCellFactory = DealsTVCellFactory(tblView: self.tableView,view:self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QRScannerView" {
            // 0 for camera and 1 for  selected image
            (segue.destination as? QRScannerViewController)?.type = 0
            (segue.destination as? QRScannerViewController)?.qrCodeCompletion = { [weak self] qrCode in
                if qrCode != nil {
                    self?.getDeailOf(qr: qrCode!)
                } else {
                    self?.hideLoader()
                    self?.showAlertWith(title: nil, message: "Unable to scan code")
                }
            }
        }
    }
    
    
    @IBAction func redeemBtnActn(_ sender: UIButton) {
        redeemButtonAction(sender)
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setData() {
        
        let deal = dealsViewModel?.deal
        contactNo = deal?.taxi?.phone_number ?? ""
        appLink = deal?.taxi?.app_link ?? ""
         titleLabel.text = deal?.title ?? ""
         distanceLabel.text = String(deal?.distance ?? 0) + "mi"
         ratingCountLabel.text = String(deal?.ratings ?? 0)
        subTitleLabel.text = deal?.provider?.name ?? ""
        var openInfo = ""
        let startDay = deal?.startDay ?? ""
        let endDay = deal?.endDay ?? ""
        openInfo = startDay + " " + endDay
        openInfo = openInfo.trimSpace()
        everyDayLabel.text = openInfo.isEmpty ? "Everyday" : openInfo
        providerImageView.kf.indicatorType = .activity
        coverImageView.kf.indicatorType = .activity
        providerImageView.kf.setImage(with: URL(string:deal?.photo ?? ""))
        coverImageView.kf.setImage(with: URL(string:deal?.coverPhoto ?? ""))
        if(deal?.web == "" && deal?.societyEmail?.replacingOccurrences(of:" ", with: "") == ""){
          
        let buttonTitle = (deal?.scanForRedeem ?? false) ? "Press for QR Reader" : "Redeem"
        redeeamBtn.setTitle(buttonTitle, for: .normal)
        }
        else if(deal?.societyEmail?.replacingOccurrences(of:" ", with: "") != ""){
            redeeamBtn.setTitle("Join Society", for: .normal)
        }
        else{
         redeeamBtn.setTitle("Open Website", for: .normal)
        }
        tableView.reloadData()
    }
  
    private func getDeailOf(qr: String) {
        APIHelper.getQrData(userId: UserData.loggedInUser!._id, qrCode: qr) { [weak self] (data, err) in
            self?.hideLoader()
            let message = data?["message"] as? String ?? ""
            let status =  (data?["status"] as? String ?? "" ) == "1"
//           self?.showAlertWith(title: status ? "Success" : "Failed", message:  message, buttonTitle: "Ok", clickHandler: {
//                if status {
//                   self?.redeemDeal()
//                }
//            })
            
            
            
            let alertController = UIAlertController(title: status ? "Success" : "Failed", message: message, preferredStyle: .alert)
            
           // let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                if status {
                    self?.redeemDeal()
                }
            })
            alertController.addAction(okAction)
            //alertController.addAction(cancelAction)
          
            let FirstSubview = alertController.view.subviews.first
            let AlertContentView = FirstSubview?.subviews.first
            for subview in (AlertContentView?.subviews)! {
                if status == true
                {
                    subview.backgroundColor = UIColor.green.withAlphaComponent(0.7)
                }else{
                    subview.backgroundColor = UIColor.red.withAlphaComponent(0.7)
                }
                subview.alpha = 0.5
                subview.layer.cornerRadius = 10
                subview.alpha = 1
            }

            
            self?.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    private func redeemDeal() {
        guard let user = UserData.loggedInUser else {
            showAlertWith(title: nil, message: "Login required!")
            return }

        let fullName = ((user.fname ?? "") + " " + (user.lname ?? "")).trimSpace()
        let parameter: [String: String] = [
            "userid":user._id,
            "fullname": fullName,
            "email":user.email ?? "",
            "dealname":deal?.title ?? ""
        ]
        APIHelper.redeemDeal(parameters: parameter) {[weak self] (data, error) in
            if error == nil {
                let isSuccess = data?["status"] as? String == "1"
                let message = data?["message"] as? String
                self?.showAlertWith(title: isSuccess ? "Success" : "Failed", message: message ?? "")
                if isSuccess {
                    APIHelper.countDealLimit(id: (self?.deal?.id ?? ""), completion: { (data, error) in
                        self?.dealsViewModel?.getData(id:self?.deal?.id ?? "")
                    })
                }
            } else {
                //Show error
            }
        }
    }
    
    @objc func openMapForPlace() {
        let latitude = deal?.location?.latitude ?? 0
        let longitude = deal?.location?.longitude ?? 0
        
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = deal?.address?.street ?? ""
        mapItem.openInMaps(launchOptions: options)
    }
    
    @objc func catchACab() {
        if let phoneCallURL = URL(string: "tel://\(contactNo.replacingOccurrences(of:" ", with: ""))") {

          let application:UIApplication = UIApplication.shared
          if (application.canOpenURL(phoneCallURL)) {
              application.open(phoneCallURL, options: [:], completionHandler: nil)
          }
        }

    }
    
    @objc func downloadApp() {
        print(appLink)
        let cabAppUrl = URL(string: appLink.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? "")
        print(cabAppUrl!)
        
        if UIApplication.shared.canOpenURL(cabAppUrl!)
        {
            UIApplication.shared.open(cabAppUrl!, options: [:], completionHandler: nil)
        }
    }
    
    
    private func redeemDealFlow(isScan: Bool) {
        if isScan {
            performSegue(withIdentifier: "QRScannerView", sender: nil)
        } else {
            showStuId()
        }
    }
    
    
    @objc func redeemButtonAction(_ sender: UIButton) {
        
        if(sender.titleLabel?.text == "Open Website"){
            Utilities.openUrlInSafari(string: deal?.web ?? "")
        }else if(sender.titleLabel?.text == "Join Society"){
            showSendMail(email: deal?.societyEmail ?? "")
        }else{
        // check limit
        if deal?.redeemType == "limited" &&  (deal?.limitTotal ?? 0) < 1 {
            showAlertWith(title: nil, message: "OOPS YOU HAVE JUST MISSED THIS ONE. KEEP A LOOK FOR NEXT ONE.")
            return
        } else { //
            if deal?.scanForRedeem ?? false { //open qr
                 redeemDealFlow(isScan: true)
            } else { //
                redeemDealFlow(isScan: false)
            }
        }
        }
      
    }
    
    private func showSendMail(email:String) {
    if MFMailComposeViewController.canSendMail() {
        let toRecipents = [email]
       
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject("Subject")
        mc.setMessageBody("", isHTML: false)
        mc.setToRecipients(toRecipents)
     //   mc.setCcRecipients(cc)
        self.present(mc, animated: true, completion: nil)
    } else {
        showAlertWith(title: nil, message: "This device not able to send email.")
    }
    }
    
    
    private func showStuId() {
        showLoader()
        
        var res = false
        DispatchQueue.main.asyncAfter(deadline: .now()+10) {
            guard res == false else{return}
            self.hideLoader()
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
            vc.willPop = true
           
            vc.dealId = self.deal?.id ?? ""
           // vc.actionClouser = {
               // self.dealsViewModel?.getData(id:self.deal?.id ?? "")
          //  }
            self.hideLoader()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let params = ["dealId":self.deal?.id ?? ""]
        ApiManager.apiObject.APIPost(action:WebServicesURL.countDealLimit,parameters: params) { (masgdata) in
            res = true
            print(masgdata)
            self.hideLoader()
            let vc = UIStoryboard(name: "Profile", bundle: nil).instantiateInitialViewController() as! ProfileViewController
            vc.dealId = self.deal?.id ?? ""
            vc.willPop = true
            //vc.actionClouser = {
            //    self.dealsViewModel?.getData(id:self.deal?.id ?? "")
            //        }
            self.hideLoader()
            self.navigationController?.pushViewController(vc, animated: true)
           // })
        }
        
    }
    
}

//MARK:- TableView Datasource
extension DealsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if deal == nil || isLoading { return 0}
        guard let redeemType = deal?.redeemType else { return 3}
        if redeemType == "unlimited" {
        return 3
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvCellFactory.cellForRowAt(indexPath: indexPath, deal:dealsViewModel?.deal, rowAction:{ deal in
            if let dealId =  deal.id {
                self.showLoader()
                self.dealsViewModel?.getData(id: dealId)
            }
            })
//        (cell as? HomeTableViewCell)?.redeemButton.addTarget(self, action: #selector(redeemButtonAction(_:)), for: .touchUpInside)
        (cell as? CellMap)?.getMeThereButton.addTarget(self, action: #selector(openMapForPlace), for: .touchUpInside)
          (cell as? CellMap)?.catchACabButton.addTarget(self, action: #selector(catchACab), for: .touchUpInside)
        (cell as? CellMap)?.downloadAppButton.addTarget(self, action: #selector(downloadApp), for: .touchUpInside)
        return cell
    }
    
  
}

extension DealsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && deal?.redeemType != "unlimited" {
            return 75.0
        }
        return UITableView.automaticDimension
    }
}

//MARK:- Cell classes

class CellText: UITableViewCell {
    
    @IBOutlet weak var dealDescriptionLabel: UILabel!
    @IBOutlet weak var legalLabel: UILabel!
}

class CellSimilar: UITableViewCell {
    
}
class CellSelling: UITableViewCell {
    @IBOutlet weak var fireHotImageView: UIImageView!
    @IBOutlet weak var sellingFastLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var leftCountLabel: UILabel!
    
}

class CellMap: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var getMeThereButton: UIButton!
    @IBOutlet weak var catchACabButton: UIButton!
    @IBOutlet weak var downloadAppButton: UIButton!
    
    func set(location:Location, address:Address?) {
        let lat = location.latitude ?? 0
        let long = location.longitude ?? 0
        let radious = location.radious ?? 1000
       let initialLocation = CLLocation(latitude: lat, longitude: long)
        let regionRadius: CLLocationDistance = CLLocationDistance(radious)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation .coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        if let address = address {
        annotation.coordinate = coordinate
        annotation.title = address.city
        annotation.subtitle = address.street
        mapView.addAnnotation(annotation)
        }
    }
}

extension DealsViewController: DealsViewModelDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.isLoading = false
            self.setData()
            self.hideLoader()
        }
       
        
    }
    
    func didReceive(error: Error) {
        isLoading = false
        hideLoader()
        showAlertWith(title: "Error!", message: error.localizedDescription)
    }
    
}
extension DealsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
}
