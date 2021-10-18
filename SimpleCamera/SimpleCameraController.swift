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
    
    // Instance variable
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()

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
        
        // Configure the session with input and output devices
        captureSession.addInput(captureDeviceInput)
        captureSession.addOutput(stillImageOutput)
        
        // Provide a camera preview
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        // Bring the camera button to front
        view.bringSubviewToFront(cameraButton)
        captureSession.startRunning()
    }
    
    // MARK: - Action methods
    
    @IBAction func capture(sender: UIButton) {
        // Set photo settings
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        
        stillImageOutput.isHighResolutionCaptureEnabled = true
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    // MARK: - Segues
    
    @IBAction func unwindToCameraView(segue: UIStoryboardSegue) {
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showPhoto" {
            let photoViewController = segue.destination as! PhotoViewController
            photoViewController.image = stillImage
        }
    }

}

extension SimpleCameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            return
        }
        
        // Get the image from the photo buffer
        guard let imageData = photo.fileDataRepresentation() else {
            return
        }
        
        stillImage = UIImage(data: imageData)
        performSegue(withIdentifier: "showPhoto", sender: self)
    }
}
