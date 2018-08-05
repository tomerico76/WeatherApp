//
//  ViewController.swift
//  WeatherApp
//
//  Created by tomer on 15/07/2018.
//  Copyright © 2018 tomer. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    class func weatherViewController() -> WeatherViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
    }
    
    
    let cities = ["293396","295277","6255152","2163355","294777","2729907","5883385","5984185","5128581","5945848"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("before new UIWeatherView")
        
        let height = UIScreen.main.bounds.size.height * (2 / 3)
        let width = UIScreen.main.bounds.size.width
        let v = UIWeatherView(frame: CGRect(x: 0, y: 0, width: width, height: height), for: cities)
        self.view.addSubview(v)
        
        v.translatesAutoresizingMaskIntoConstraints = false
        let con = NSLayoutConstraint(item: v, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let con1 = NSLayoutConstraint(item: v, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let con2 = NSLayoutConstraint(item: v, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        let con3 = NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        
        self.view.addConstraints([con, con1, con2, con3])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

