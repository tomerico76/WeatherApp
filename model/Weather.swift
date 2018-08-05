//
//  File.swift
//  MyWeather
//
//  Created by tomer on 12/07/2018.
//  Copyright © 2018 tomer. All rights reserved.
//

import UIKit
import SDWebImage

class Weather : NSObject {
    
    var resultCode : Int16 = 0
    var id : Int = 0
    var cityName : String = "Unknown"
    var temperture : Double = 0
    var weather : String = "Unknown"
    var iconUrl : URL? = nil
    
    override init() {
        super.init()
    }
    
    required init(_ dict : [String:Any]) {
        super.init()
        print("in weather constructore")
        self.resultCode = dict["cod"] as? Int16 ?? 0
        
        if self.resultCode == 200{
            self.id = dict["id"] as? Int ?? 0
            self.cityName = dict["name"] as? String ?? "Unknown"
            if let sys = dict["sys"] as? [String:Any]{
                if let country = sys["country"] as? String{
                    self.cityName += " / " + country
                }
            }
            let main = dict["main"] as! [String:Any]
            self.temperture = main["temp"] as? Double ?? 0.0
            
            let tempIcon = dict["weather"] as! [[String:Any]]
            self.weather = tempIcon.first!["description"] as! String
            
            let iconCode = tempIcon.first!["icon"] as! String    //["icon"] as!
            iconUrl = URL(string: "http://openweathermap.org/img/w/\(iconCode).png")
        }else{
            self.cityName = dict["message"] as? String ?? "Unknown"
            self.resultCode = dict["cod"] as? Int16 ?? 0
            self.id = dict["id"] as? Int ?? 0
        }
    }
}
