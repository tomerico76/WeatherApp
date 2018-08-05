//
//  File.swift
//  MyWeather
//
//  Created by tomer on 12/07/2018.
//  Copyright © 2018 tomer. All rights reserved.
//

import Foundation
import Alamofire


class WeatherManager: NSObject {
    //singleton manager
    static let manager = WeatherManager()
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?id="
    private let privateKey = "&APPID=d2bd923726d8850b7677856f80cb52cd"
    private let units = "&units=metric"
    
    
    typealias DictionaryResultCompletion = (JSON?, Error?) -> Void
    
    private func sendGetRequest(cityID : String, completion : @escaping DictionaryResultCompletion){
        
        let url : String = baseURL + cityID + units + privateKey
        
        Alamofire.request(url).responseJSON { (dataRes) in
            
            guard let json = dataRes.result.value as? JSON, json["cod"] as? Int16 == 200 else{
                print("in guard")
                //there is an error
                if dataRes.error != nil{
                    completion(nil, dataRes.error)
                    return
                }
            
                completion(dataRes.result.value as? JSON, nil)
                return
            }
            completion(json, nil)
        }
    }
    
    //the external func to use in order to get a weather by id number as String
    func getWeather(cityID : String, completion : @escaping (Weather , Error?)->Void){
        if isInternet{
            sendGetRequest(cityID: cityID) { (Json, err) in
                var weather : Weather = Weather()
                if err != nil{
                    print(err?.localizedDescription ?? "No Error")
                    if (err?.localizedDescription.contains("offline"))!{
                        weather = Weather(["message":"No Internet Connection!", "cod":Int16(-1), "id":Int(cityID)!])
                    }else{
                        weather = Weather(["message":"Unknown Error", "id":Int(cityID)!])
                    }
                }else{
                    weather = Weather(Json!)
                }
                
                completion(weather, err)
            }
        }else{
            let weather = Weather(["message":"No Internet Connection!", "cod":Int16(-1), "id":Int(cityID)!])
            //Toast
            "No Internet Connection!".toast()
            completion(weather, nil)
        }
    }
}
