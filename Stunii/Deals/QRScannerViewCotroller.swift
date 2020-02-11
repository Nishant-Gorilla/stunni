//
//  QRScannerViewCotroller.swift
//  Stunii
//
//  Created by inderjeet on 08/09/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: BaseViewController {
    @IBOutlet weak var containerView: CodeScannerView!
    typealias qrCodeResponse = (String?) -> ()
    var qrCodeCompletion: qrCodeResponse?
    var type: Int = 0
    
    var captureSession = AVCaptureSession()
    var imageView: UIImageView?
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    override func viewDidLoad() {
        super.viewDidLoad()
        type == 0 ? scanFromCamera() : scannFromImage()
       
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    func launchApp(decodedURL: String) {
        if decodedURL == "" {
            showAlert(message: "No information found")
        }else{
            qrCodeCompletion?(decodedURL)
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func canceButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: containerView.layer.frame.width, height: containerView.layer.frame.height)
        imageView?.frame = CGRect(x: 0, y: 0, width: containerView.layer.frame.width, height: containerView.layer.frame.height)
        
    }
    
    private func scannFromImage() {
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFit
        containerView.backgroundColor = .clear
        containerView?.addSubview(imageView!)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func scanFromCamera() {
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.default(for: .video)
        guard let captureDevice = deviceDiscoverySession else {
           print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error.localizedDescription)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        containerView.layer.addSublayer(videoPreviewLayer!)
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        //        view.bringSubview(toFront: messageLabel)
        //        view.bringSubview(toFront: topbar)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            containerView.addSubview(qrCodeFrameView)
            containerView.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
    private func scaenQR(on image: UIImage?) {
        guard let image = image else { return }
        imageView?.image = image
        let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        let ciImage:CIImage=CIImage(image:image)!
        var qrCodeLink=""
        
        let features=detector.features(in: ciImage)
        for feature in features as! [CIQRCodeFeature] {
            qrCodeLink += feature.messageString!
        }
        
        if qrCodeLink=="" {
            showAlert(message: "No information found")
        }else{
            qrCodeCompletion?(qrCodeLink)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func showAlert(message: String) {
        self.hideLoader()
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
}

extension QRScannerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: {
            self.scaenQR(on: info[UIImagePickerController.InfoKey.originalImage] as? UIImage)
        })
    }
}



extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //  messageLabel.text = "No QR code is detected"
            return
        }
        self.showLoader()
        captureSession.stopRunning()

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(decodedURL: metadataObj.stringValue!)
                // messageLabel.text = metadataObj.stringValue
            }
        }
    }
    
}
