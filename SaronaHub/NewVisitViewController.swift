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
    @IBOutlet weak var qrCodeFrameView: UIView!
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera],
                                                                  mediaType: AVMediaType.video,
                                                                  position: .back)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let captureDevice = self.deviceDiscoverySession.devices.first {
            if let input = try? AVCaptureDeviceInput(device: captureDevice) {
                self.captureSession.addInput(input)
                let captureMetadataOutput = AVCaptureMetadataOutput()
                self.captureSession.addOutput(captureMetadataOutput)
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = [.qr]
            } else {
                print("error")
            }
            self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        } else {
            print("Failed to get the camera device")
        }
    }
    
    override func viewDidLayoutSubviews() {
        if let videoPreviewLayer = self.videoPreviewLayer {
            videoPreviewLayer.frame = self.qrCodeFrameView.bounds
            self.qrCodeFrameView.layer.addSublayer(videoPreviewLayer)
        }
        self.qrCodeFrameView.clipsToBounds = true
        self.qrCodeFrameView.layer.cornerRadius = 20
        self.captureSession.startRunning()
    }
}

extension NewVisitViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.isEmpty {
            self.titleLabel.text = "סרוק את הברקוד בכניסתך ויציאתך מהמתחם."
        } else if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject, let metadataStr = metadataObj.stringValue {
            self.titleLabel.text = metadataStr
        }
    }
}
