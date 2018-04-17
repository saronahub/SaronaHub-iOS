//
//  NewVisitViewController.swift
//  SaronaHub
//
//  Created by Asaf Baibekov on 17.4.2018.
//  Copyright © 2018 Asaf Baibekov. All rights reserved.
//

import UIKit
import AVFoundation

class NewVisitViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var qrCodeFrameView: UIView!
    
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

        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInMicrophone,.builtInTelephotoCamera,.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        if let input = try? AVCaptureDeviceInput(device: captureDevice) {
            self.captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            self.captureSession.addOutput(captureMetadataOutput)
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = self.supportedCodeTypes
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } else {
            print("error")
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        
        
        
        self.videoPreviewLayer.frame = self.qrCodeFrameView.bounds
        self.qrCodeFrameView.layer.addSublayer(self.videoPreviewLayer)
        
        // Start video capture.
        self.captureSession.startRunning()
        
        
    }
}

extension NewVisitViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.isEmpty {
//            self.qrCodeFrameView.frame = CGRect.zero
//            messageLabel.text = "No QR code is detected"
            self.titleLabel.text = "סרוק את הברקוד בכניסתך ויציאתך מהמתחם."
            print("No QR code is detected")
            return
        } else if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            // Get the metadata object.
            if self.supportedCodeTypes.contains(metadataObj.type) {
                // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
//                let barCodeObject = videoPreviewLayer.transformedMetadataObject(for: metadataObj)
//                print(barCodeObject)
//                self.qrCodeFrameView.frame = barCodeObject!.bounds
                if let metadataStr = metadataObj.stringValue {
                    self.titleLabel.text = metadataStr
                    print(metadataStr)
                }
            }
        }
    }
}
