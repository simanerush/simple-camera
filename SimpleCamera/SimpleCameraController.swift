//
//  SimpleCameraController.swift
//  SimpleCamera
//
//  Created by Simon Ng on 16/10/2019.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class SimpleCameraController: UIViewController {

    @IBOutlet var cameraButton:UIButton!
    
    // Input variables
    let captureSession = AVCaptureSession()
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice!
    
    // Output variables
    var stillImageOutput: AVCapturePhotoOutput!
    var stillImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func configure() {
        // Preset the session for taking the photo in full resolution
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        // Get the front and back-facing camera for taking photo
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        
        for device in deviceDiscoverySession.devices {
            if device.position == .back {
                backFacingCamera = device
            } else if device.position == .front {
                frontFacingCamera = device
            }
        }
        
        // By default, camera app uses the back-facing camera when it's first enabled
        currentDevice = backFacingCamera
        
        guard let captureDeviceInput = try?
                AVCaptureDeviceInput(device: currentDevice) else {
                    return
                }
        
        // Configure the session for outputting still images
        stillImageOutput = AVCapturePhotoOutput()
    }
    
    // MARK: - Action methods
    
    @IBAction func capture(sender: UIButton) {
    }

    // MARK: - Segues
    
    @IBAction func unwindToCameraView(segue: UIStoryboardSegue) {
    
    }

}
