//
//  RegisterLoginViewController.swift
//  WeatherApp
//
//  Created by tomer on 31/07/2018.
//  Copyright © 2018 tomer. All rights reserved.
//

import UIKit

class RegisterLoginViewController: UIViewController, CameraViewControllerDeledate, AmazonManagerDelegate {
    
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    
    var isRegister : Bool? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if activityIndicatorOutlet.isAnimating{
            activityIndicatorOutlet.stopAnimating()
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("in prepare")
        if let cameraViewController = segue.destination as? CameraViewController{
            print("is cameraViewController")
            cameraViewController.delegate = self
        }
        
        let button = sender as? UIButton
        switch button?.tag {
        case 10:
            isRegister = true
        case 20:
            isRegister = false
        default:
            break
        }
    }
    
    //MARK: - delegate function -
    func getImageData(imageData: Data) {
        if isInternet{
            self.activityIndicatorOutlet.startAnimating()
            if isRegister!{
                register(imageData: imageData)
            }else{
                //download from s3 and compare
                login(imageData: imageData)
            }
        }else{
            "No Internet Connection! Please Try Later.".toast()
        }
    }
    
    //MARK: - Amazon manager functions(upload,download) -
    private func register(imageData: Data){
        //upload to s3
        var completionHandler : UploadCompletionHandler?
        completionHandler = {(task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error{
                    error.localizedDescription.toast()
                    return
                }
                "Register Completed!".toast()
                self.activityIndicatorOutlet.stopAnimating()
            })
        }
        AmazonManager.manager.uploadData(data: imageData, completionHandler: completionHandler)
    }
    
    private func login(imageData: Data){
        var completionHandler : DownloadCompletionHandler?
        completionHandler = { (task, URL, data, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error{
                    error.localizedDescription.toast()
                    return
                }
                let amazonManager = AmazonManager.manager
                amazonManager.delegate = self
                amazonManager.startRekognition(registeredImageData: data!, loginImageData: imageData)
            })
        }
        AmazonManager.manager.downloadData(completionHandler: completionHandler)
    }
    
    //MARK: - delegate function -
    func didCompare(isSuccesful: Bool) {
        print("in didCompare, isSuccesful: \(isSuccesful)")
        if isSuccesful{
            DispatchQueue.main.async(execute: {
                "Login Succes".toast()
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let viewController = storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController//WeatherViewController.weatherViewController()
                self.navigationController?.show(viewController, sender: self)
            })
        }else{
            DispatchQueue.main.async(execute: {
                "Face did not match!!! Please try again.".toast()
            })
        }
        DispatchQueue.main.async(execute: {
            self.activityIndicatorOutlet.stopAnimating()
        })
    }
    
    //MARK:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
