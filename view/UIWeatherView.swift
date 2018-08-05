//
//  UIWeatherView.swift
//  WeatherApp
//
//  Created by tomer on 17/07/2018.
//  Copyright © 2018 tomer. All rights reserved.
//

import UIKit

class UIWeatherView: UIView, UIWeatherViewDelegate {
    
    
    //MARK: - Inspectable(from storyboard) property -
    //the city list of ids
    @IBInspectable var citiesCodesSeparateWithComa : String = ""{
        didSet{
            self.setup(cities: cityStrCodes)
        }
    }
    //returns an array of cities ids
    private var cityStrCodes : [String]{
        get{
            print("in city codes")
            return self.citiesCodesSeparateWithComa.components(separatedBy: ",")
        }
    }
    //returns true if there are stand by tasks
    var isStandByTasks : Bool{
        get{
            return standByTasks.contains(true)
        }
    }
   
    //MARK: - properties -
    //internet reachability object to be used for internet connection changes
    private var reachability : Reachability? = nil
    private var indView : UIIndicatoreView?
    //where the weather/city data is displayed
    private var cityView : UICityView?
    private var cityArr : [Weather] = []
    private var standByTasks : [Bool] = []
    //index for the current(viewed) weather/city
    private var cityArrIndex : Int = 0
    
    //MARK: - init functions -
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(cities: [])
    }
    
    init(frame: CGRect, for cities : [String]) {
        super.init(frame: frame)
        setup(cities: cities)
    }
    
    private func setup(cities : [String]){
        //initializing arrays with default values, with the size of the cities ids
        //array
        cityArr = Array(repeating: Weather(), count: cities.count)
        standByTasks = Array(repeating: false, count: cities.count)
        self.tag = 22
        cityArrIndex = 0
        self.isUserInteractionEnabled = true
        //self.backgroundColor = .gray
        addCityView()
        loadAll(cities: cities)
        
        cityView?.delegateWeather = self
    }
    
    private func addCityView(){
        self.cityView = UICityView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - UIIndicatoreView.viewHeight))
        guard let cityV = self.cityView else {
            print("in guard")
            return
        }
        //cityV.backgroundColor = .green
        self.addSubview(cityV)
        cityV.translatesAutoresizingMaskIntoConstraints = false
        
        let con = NSLayoutConstraint(item: cityV, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let con1 = NSLayoutConstraint(item: cityV, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let con2 = NSLayoutConstraint(item: cityV, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let con3 = NSLayoutConstraint(item: cityV, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: UIIndicatoreView.viewHeight * -1 /*self.frame.height*/)
        
        self.addConstraints([con, con1, con2, con3])
    }
    
    //gets all cities weather data
    func loadAll(cities : [String]) {
        for index in 0..<cities.count{
            print("index: \(index)")
            getCityWeather(cityCode: cities[index], forIndex: index, arrCount: cities.count)
        }
    }
    
    private func getCityWeather(cityCode : String, forIndex index : Int, arrCount : Int){
        print("getCityWeather")
        WeatherManager.manager.getWeather(cityID: cityCode) { (weather, err) in
            
            //sets the standby task for the respected index(city)
            self.standByTasks[index] = weather.resultCode == -1
            
            if weather.resultCode == -1 && self.reachability == nil {
                //no internet code and no Reachability object
                self.activateReachabilityObserver()
            }
            self.cityArr[index] = weather
            
            if index == arrCount - 1 {
                self.addIndicatorView()
                self.cityView?.loadView(weather: self.cityArr[self.cityArrIndex])
            }
        }
    }
    
    private func addIndicatorView() {
        self.indView = UIIndicatoreView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 70), numberOfItems: self.cityArr.count < 1 ? 0 : self.cityArr.count)
        guard let indV = self.indView else {
            print("in guard")
            return
        }
        
        //indV.numberOfItems is the computed amount of indicators that
        //can be presented in the views width.
        if indV.numberOfItems < self.cityArr.count{
            //if numberOfItems is smaller, the arrays needs to be shortened
            //by temp
            let temp = self.cityArr.count - indV.numberOfItems
            self.cityArr.removeLast(temp)
            self.standByTasks.removeLast(temp)
        }
        self.addSubview(indV)
        indV.translatesAutoresizingMaskIntoConstraints = false
        let con = NSLayoutConstraint(item: indV, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let con1 = NSLayoutConstraint(item: indV, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let con2 = NSLayoutConstraint(item: indV, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.frame.width)
        let con3 = NSLayoutConstraint(item: indV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIIndicatoreView.viewHeight /*self.frame.height*/)
        
        self.addConstraints([con, con1, con2, con3])
        //delegate
        self.cityView?.delegateIndicator = indView
        self.indView?.delegateWeather = self
    }
    
    //MARK: - delegate function -
    func loadWeatherViewByDirection(right: Bool, index: Int?, fromBackground: Bool) {
        let direction = right ? 1 : -1
        var temp = 0
        if index != nil{
            temp = index!
        }else{
            temp = validateCityIndex(newIndex: cityArrIndex + direction)
        }
        
        if cityArrIndex != temp || fromBackground{
            self.cityArrIndex = temp
            WeatherManager.manager.getWeather(cityID: String(cityArr[self.cityArrIndex].id)) { (newWeather, err) in
                
                self.standByTasks[self.cityArrIndex] = newWeather.resultCode == -1
                //preventing a full loaded weathre object to be replaced
                //with en empty(no internet) object
                if newWeather.resultCode != -1 {
                    self.cityArr[self.cityArrIndex] = newWeather
                }else{
                    //No internet connection
                    if self.reachability == nil{
                        self.activateReachabilityObserver()
                    }
                }
                self.cityView?.loadView(weather: self.cityArr[self.cityArrIndex])
            }
        }
    }
    
    //preventing the new index from exceeding the bounds of the array
    private func validateCityIndex(newIndex : Int) -> Int{
        var tempIndex = 0
        if newIndex > cityArr.count - 1{
            tempIndex = cityArr.count - 1
        }else if newIndex < 0{
            tempIndex = 0
        }else{
            tempIndex = newIndex
        }
        return tempIndex
    }

    //MARK: - Internet reachability -
    //initializing reachability object, declaring observer, start observing
    //for internet connection changes.
    //this func in only being called when the App tries to download a weather when there is no internet,
    //nad only once(when reachability object is nil)
    private func activateReachabilityObserver(){
        self.reachability = Reachability.forInternetConnection()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: .reachabilityChanged, object: self.reachability)
        self.reachability?.startNotifier()
    }
    
    //this func will be called when internet connection changes(when the internet connection is resumed).
    //when internet becomes available: stop the observer, removes the observer, reachability object set
    //to nil so the next time there is no internet the activateReachabilityObserver() will be called,
    //and calls the resume stand by func.
    @objc func reachabilityChanged(note : Notification) {
        print("reachabilityChanged")
        let changedReachability = note.object as! Reachability
        switch changedReachability.currentReachabilityStatus() {
        case NotReachable:
            //internet becomes unavailable
            print("not reachable")
        default:
            //internet becomes available
            print("is reachable")
            reachability?.stopNotifier()
            NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
            reachability = nil
            resumeStandByTasks()
        }
    }
    
    //downloads all the weather objects that were not downloaded because there was no internet connection
    private func resumeStandByTasks() {
        print("resumeStandByTasks")
        if standByTasks.contains(true){
            print("stand by contains true")
            for i in 0..<standByTasks.count{
                //only operate on standby tasks (boolean == true)
                if standByTasks[i]{
                    WeatherManager.manager.getWeather(cityID: String(cityArr[i].id)) { (newWeather, err) in
                        self.standByTasks[i] = newWeather.resultCode == -1
                        self.cityArr[i] = newWeather
                        //if the downloaded object is the current viewed object then load the data to the view
                        if i == self.cityArrIndex{
                            self.cityView?.loadView(weather: self.cityArr[self.cityArrIndex])
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - return from background func -
    //will only download the current city weather
    func resumeFromBackground(){
        loadWeatherViewByDirection(right: true, index: cityArrIndex, fromBackground: true)
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
