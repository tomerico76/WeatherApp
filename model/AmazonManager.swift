//
//  AmazonManager.swift
//  WeatherApp
//
//  Created by tomer on 31/07/2018.
//  Copyright © 2018 tomer. All rights reserved.
//

import UIKit
import AWSS3
import AWSRekognition

class AmazonManager: NSObject {

    static let manager = AmazonManager()
    
    var delegate : AmazonManagerDelegate?
    
    //MARK: - computed properties -
    private var bucketName : String{
        get{
            return getBucketName
        }
    }
    
    private var bucketImageKeyReg : String{
        get{
            return "regImage.jpg"
        }
    }
    
    private var bucketImageKeyLogin : String{
        get{
            return "loginImage.jpg"
        }
    }
    
    //MARK: - functions -
    func uploadData(data : Data, completionHandler : UploadCompletionHandler?) {
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data,
                      bucket: bucketName,
                      key: bucketImageKeyReg,
                      contentType: "image/jpg",
                      expression: nil,
                      completionHandler: completionHandler).continueWith {
                        (task) -> Any? in
                        if let error = task.error{
                            print("Error: \(error.localizedDescription)")
                        }
                        if task.result != nil{
                            print("in task")
                        }
                        return nil
        }
    }
    
    func downloadData(completionHandler : DownloadCompletionHandler?){
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.downloadData(fromBucket: bucketName,
                        key: bucketImageKeyReg,
                        expression: nil,
                        completionHandler: completionHandler
            ).continueWith {
                (task) -> Any? in
                if let error = task.error{
                    print("Error: \(error.localizedDescription)")
                }
                if task.result != nil{
                    print("in task")
                }
                return nil
        }
    }
    
    func startRekognition(registeredImageData : Data, loginImageData : Data){
        print("startReko")

        //var isCompare : Bool = false
        
        let regImage = AWSRekognitionImage()
        regImage?.bytes = registeredImageData
        
        let loginImage = AWSRekognitionImage()
        loginImage?.bytes = loginImageData
        
        let request = AWSRekognitionCompareFacesRequest()
        
        request?.similarityThreshold = 85
        request?.sourceImage = regImage
        request?.targetImage = loginImage
        
        let rekognition = AWSRekognition.default()
        rekognition.compareFaces(request!) { (res, err) in
            print("in compare")
            
            if err != nil{
                print("in error")
                self.delegate?.didCompare(isSuccesful: false)
                return
            }
            if let result = res{
                print("in result")
                if (result.faceMatches?.isEmpty)!{
                    print("in result false")
                    self.delegate?.didCompare(isSuccesful: false)
                }else{
                    print("in result true")
                    self.delegate?.didCompare(isSuccesful: true)
                }
            }
        }
    }
}
