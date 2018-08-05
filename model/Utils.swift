//
//  Utils.swift
//  WeatherApp
//
//  Created by tomer on 21/07/2018.
//  Copyright © 2018 tomer. All rights reserved.
//

import Foundation
import AWSS3

typealias JSON = [String:Any]
typealias UploadCompletionHandler = AWSS3TransferUtilityUploadCompletionHandlerBlock
typealias DownloadCompletionHandler = AWSS3TransferUtilityDownloadCompletionHandlerBlock

//MARK: - Checking for internet connection
var isInternet : Bool{
    get{
        let reachability : Reachability = Reachability.forInternetConnection()
        return reachability.currentReachabilityStatus() == NotReachable ? false : true
    }
}

//from the file awsconfiguration.json
var getPoolID : String{
    get{
        if let url = Bundle.main.url(forResource: "awsconfiguration", withExtension: "json"){
            do{
                let s = try String(contentsOf: url)
                let data = s.data(using: String.Encoding.utf8)!
                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSON
                let result = (((dict["CredentialsProvider"] as? JSON)?["CognitoIdentity"] as? JSON)?["Default"] as? JSON)?["PoolId"] as? String
                if let poolID = result{
                    return poolID
                }else{
                    return "Pool ID could not be found!!!"
                }
            }catch{
                print("error: \(error.localizedDescription)")
                return "error: \(error.localizedDescription)"
            }
        }
        return "The file awsconfiguration.json could not be found!!!"
    }
}

//from the file awsconfiguration.json
var getBucketName : String{
    get{
        if let url = Bundle.main.url(forResource: "awsconfiguration", withExtension: "json"){
            do{
                let s = try String(contentsOf: url)
                let data = s.data(using: String.Encoding.utf8)!
                let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSON
                let result = ((dict["S3TransferUtility"] as? JSON)?["Default"] as? JSON)?["Bucket"] as? String
                if let bucketName = result{
                    return bucketName
                }else{
                    return "Bucket Name could not be found!!!"
                }
            }catch{
                print("error: \(error.localizedDescription)")
                return "error: \(error.localizedDescription)"
            }
        }
        return "The file awsconfiguration.json could not be found!!!"
    }
}
