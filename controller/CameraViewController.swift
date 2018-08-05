//
//  CameraViewController.swift
//  CameraTest
//
//  Created by tomer on 30/07/2018.
//  Copyright © 2018 tomer. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet weak var previewViewOutlet: UIView!
    
    @IBOutlet weak var cameraButtonOutlet: UIButton!
    
    var delegate : CameraViewControllerDeledate?
    
    let mediaType = AVMediaType.video
    
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var capturePhotoOutput : AVCapturePhotoOutput?
    var isFlash : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        cameraButtonOutlet.setImage(#imageLiteral(resourceName: "icon_camera_w"), for: .normal)
        cameraButtonOutlet.setImage(#imageLiteral(resourceName: "icon_camera_b"), for: .highlighted)
        
        cameraAuthorizationCheck()
        let cpDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front)
        guard let captureDevice = cpDevice else {
            return
        }
        
        isFlash = captureDevice.hasFlash
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            captureSession?.addOutput(capturePhotoOutput!)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            previewViewOutlet.layer.addSublayer(videoPreviewLayer!)
            captureSession?.startRunning()
            
        }catch{
            print("error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func onTapTakePhoto(_ sender: Any) {
        print("onTapTakePhoto")
        guard let capturePhotoOutput = self.capturePhotoOutput else {
            print("in guard")
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        if isFlash {
           photoSettings.flashMode = .auto
        }else{
            photoSettings.flashMode = .off
        }

        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    //authorizing camera
    func cameraAuthorizationCheck(){
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
            //show alert
            let alert = UIAlertController(title: "Error", message: "Please authorize Camera use", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Nope", style: .cancel, handler: nil))
            func handler(_ action : UIAlertAction){
                guard let url = URL(string: UIApplicationOpenSettingsURLString) else{
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            alert.addAction(UIAlertAction(title: "Settings", style: .destructive, handler: handler))
            
            let rootVC = UIApplication.shared.delegate?.window??.rootViewController
            rootVC?.present(alert, animated: true, completion: nil)
            
        case .authorized: break
        case .restricted: break
            
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: mediaType) { granted in
                if granted {
                    print("Granted access to \(self.mediaType)")
                } else {
                    print("Denied access to \(self.mediaType)")
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        captureSession?.stopRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CameraViewController : AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard error == nil else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        let imageData = photo.fileDataRepresentation()
        
        self.delegate?.getImageData(imageData: imageData!)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}
