//
//  CityView.swift
//  WeatherApp
//
//  Created by tomer on 17/07/2018.
//  Copyright © 2018 tomer. All rights reserved.
//

import UIKit
import SDWebImage

class UICityView: UIView, UIGestureRecognizerDelegate {

    //MARK: - properties -
    var delegateIndicator : UIIndicatoreViewDelegate?
    var delegateWeather : UIWeatherViewDelegate?
    
    var weatherView : UIView?
    var cityNameLabel : UILabel?
    var secondView : UIView?
    var temperatureLabel : UILabel?
    var iconView : UIImageView?
    var conditionLabel : UILabel?
    
    //MARK: - computed properties -
    var viewsHeight : CGFloat{
        get{
            if let wV = weatherView{
                return wV.frame.height / 4
            }else{
                return 0
            }
        }
    }
    
    var viewsWidth : CGFloat{
        get{
            if let wV = weatherView{
                return wV.frame.width - (2 * viewsHorizontalSpaces)
            }else{
                return 0
            }
        }
    }
    
    var viewsVerticalSpaces : CGFloat{
        get{
            if weatherView != nil{
                return viewsHeight / 4
            }else{
                return 0
            }
        }
    }
    
    var viewsHorizontalSpaces : CGFloat{
        get{
            return 20
        }
    }
    
    //MARK: - computed properties -
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup(){
        createViews()
        addGestures()
    }
    
    //MARK: - other functions -
    //creates the views(#3) in witch the weather data will be presented
    private func createViews() {
        //root view
        weatherView = UIView(frame: CGRect(x: 20, y: 20, width: self.frame.width - 40, height: self.frame.height - 40))
        //weatherView?.backgroundColor = .gray
        self.clipsToBounds = false
        weatherView?.clipsToBounds = false
        self.addSubview(weatherView!)
        
        addFirstView()
        addSecondView()
        addThirdView()
    }
    
    private func addFirstView(){
        //first view is only a UILabelView
        cityNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewsWidth, height: viewsHeight))
        cityNameLabel?.clipsToBounds = true
        cityNameLabel?.numberOfLines = 2
        cityNameLabel?.font = UIFont.boldSystemFont(ofSize: viewsHeight)
        cityNameLabel?.textAlignment = .center
        cityNameLabel?.adjustsFontSizeToFitWidth = true
        cityNameLabel?.minimumScaleFactor = 0.3
        //cityNameLabel?.backgroundColor = .white
        weatherView?.addSubview(cityNameLabel!)
        
        //the constraints setup
        cityNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        let con = NSLayoutConstraint(item: cityNameLabel!, attribute: .leading, relatedBy: .equal, toItem: weatherView, attribute: .leading, multiplier: 1, constant: viewsHorizontalSpaces)
        let con1 = NSLayoutConstraint(item: cityNameLabel!, attribute: .trailing, relatedBy: .equal, toItem: weatherView, attribute: .trailing, multiplier: 1, constant: viewsHorizontalSpaces * -1)
        let con2 = NSLayoutConstraint(item: cityNameLabel!, attribute: .top, relatedBy: .equal, toItem: weatherView, attribute: .top, multiplier: 1, constant: viewsVerticalSpaces)
        let con3 = NSLayoutConstraint(item: cityNameLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewsHeight)
        
        self.addConstraints([con, con1, con2, con3])
    }
    
    private func addSecondView(){
        secondView = UIView(frame: CGRect(x: 0, y: 0, width: viewsWidth, height: viewsHeight))
        //secondView?.backgroundColor = .red
        weatherView?.addSubview(secondView!)
        
        //the constraints setup for the second view
        //first 4 declared with var in order of saving memory(8 constraints instead of 12)
        secondView?.translatesAutoresizingMaskIntoConstraints = false
        var con = NSLayoutConstraint(item: secondView!, attribute: .leading, relatedBy: .equal, toItem: weatherView, attribute: .leading, multiplier: 1, constant: viewsHorizontalSpaces)
        var con1 = NSLayoutConstraint(item: secondView!, attribute: .trailing, relatedBy: .equal, toItem: weatherView, attribute: .trailing, multiplier: 1, constant: viewsHorizontalSpaces * -1)
        var con2 = NSLayoutConstraint(item: secondView!, attribute: .top, relatedBy: .equal, toItem: cityNameLabel!, attribute: .bottom, multiplier: 1, constant: viewsVerticalSpaces)
        var con3 = NSLayoutConstraint(item: secondView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewsHeight)
        
        self.addConstraints([con, con1, con2, con3])
        
        //temperature label setup
        temperatureLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewsWidth, height: viewsHeight))
        temperatureLabel?.font = UIFont.boldSystemFont(ofSize: viewsHeight)
        temperatureLabel?.textAlignment = .center
        temperatureLabel?.adjustsFontSizeToFitWidth = true
        temperatureLabel?.minimumScaleFactor = 0.3
        temperatureLabel?.baselineAdjustment = .alignCenters
        //temperatureLabel?.backgroundColor = .gray
        secondView?.addSubview(temperatureLabel!)
        //icon view setup
        iconView = UIImageView()
        iconView?.clipsToBounds = true
        iconView?.contentMode = .scaleAspectFit
        //iconView?.backgroundColor = .blue
        secondView?.addSubview(iconView!)
        
        //the constraints setup in the second view for temperature label and
        //icon view
        temperatureLabel?.translatesAutoresizingMaskIntoConstraints = false
        iconView?.translatesAutoresizingMaskIntoConstraints = false
        
        con = NSLayoutConstraint(item: iconView!, attribute: .centerY, relatedBy: .equal, toItem: secondView, attribute: .centerY, multiplier: 1, constant: 0)
        con1 = NSLayoutConstraint(item: iconView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewsHeight)
        con2 = NSLayoutConstraint(item: iconView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewsHeight)
        con3 = NSLayoutConstraint(item: iconView!, attribute: .trailing, relatedBy: .equal, toItem: secondView, attribute: .trailing, multiplier: 1, constant: 5)
        let con4 = NSLayoutConstraint(item: temperatureLabel!, attribute: .centerY, relatedBy: .equal, toItem: secondView, attribute: .centerY, multiplier: 1, constant: 0)
        let con5 = NSLayoutConstraint(item: temperatureLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewsHeight)
        let con6 = NSLayoutConstraint(item: temperatureLabel!, attribute: .leading, relatedBy: .equal, toItem: secondView, attribute: .leading, multiplier: 1, constant: 5)
        let con7 = NSLayoutConstraint(item: temperatureLabel!, attribute: .trailing, relatedBy: .equal, toItem: iconView, attribute: .leading, multiplier: 1, constant: -5)
        
        secondView?.addConstraints([con, con1, con2, con3, con4, con5, con6, con7])
    }
    
    private func addThirdView(){
        //third view is only a UILabelView
        conditionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewsWidth, height: viewsHeight))
        conditionLabel?.clipsToBounds = false
        conditionLabel?.numberOfLines = 1
        print("view width: \(viewsHeight)")
        conditionLabel?.font = UIFont.boldSystemFont(ofSize: viewsHeight * 0.9)
        conditionLabel?.textAlignment = .center
        conditionLabel?.baselineAdjustment = .alignCenters
        conditionLabel?.adjustsFontSizeToFitWidth = true
        conditionLabel?.minimumScaleFactor = 0.3
        //conditionLabel?.backgroundColor = .white
        weatherView?.addSubview(conditionLabel!)
        //the constraints setup
        conditionLabel?.translatesAutoresizingMaskIntoConstraints = false
        let con = NSLayoutConstraint(item: conditionLabel!, attribute: .leading, relatedBy: .equal, toItem: weatherView, attribute: .leading, multiplier: 1, constant: viewsHorizontalSpaces)
        let con1 = NSLayoutConstraint(item: conditionLabel!, attribute: .trailing, relatedBy: .equal, toItem: weatherView, attribute: .trailing, multiplier: 1, constant: viewsHorizontalSpaces * -1)
        let con2 = NSLayoutConstraint(item: conditionLabel!, attribute: .top, relatedBy: .equal, toItem: secondView, attribute: .bottom, multiplier: 1, constant: viewsVerticalSpaces)
        let con3 = NSLayoutConstraint(item: conditionLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewsHeight)
        
        self.addConstraints([con, con1, con2, con3])
    }
    
    //loads the weather data to the different views
    func loadView(weather : Weather){
        print("in loadview")
        enum ExtraColors{
            case darkGreen
            case lightBlue
            
            var color : UIColor{
                switch self {
                case .darkGreen: return #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
                case .lightBlue: return #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
                }
            }
        }
        //computed property, returns the correct color for the corresponding temperature
        var tempColor : UIColor{
            get{
                let temp = weather.temperture
                if temp >= 30{
                    return .red
                }
                if temp <= 0{
                    return .blue
                }
                if temp >= 25 && temp < 30{
                    return .orange
                }
                if temp >= 18 && temp < 25{
                    return ExtraColors.darkGreen.color
                }
                if temp >= 10 && temp < 18{
                    return .green
                }else{
                    return ExtraColors.lightBlue.color
                }
            }
        }
        
        cityNameLabel?.text = weather.cityName
        
        temperatureLabel?.textColor = tempColor
        temperatureLabel?.text = String(weather.temperture) + "℃"
        
        if let url = weather.iconUrl{
            iconView?.sd_setImage(with: url)
        }else{
            iconView?.image = #imageLiteral(resourceName: "no_image")
            iconView?.sd_cancelCurrentImageLoad()
        }
        
        conditionLabel?.text = weather.weather
    }
    
    //MARK: - gesture functions -
    private func addGestures(){
        self.isUserInteractionEnabled = true
        
        let gestureRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesturePressed))
        gestureRight.delegate = self
        gestureRight.direction = .right
        self.addGestureRecognizer(gestureRight)
        
        let gestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesturePressed))
        gestureLeft.delegate = self
        gestureLeft.direction = .left
        self.addGestureRecognizer(gestureLeft)
    }
    
    @objc func swipeGesturePressed(sender: UISwipeGestureRecognizer) {
        print("in swipeGesturePressed")
        //when swiping left we need to load the view from the right side
        //of the weather array(index+1) and vice versa (with index-1)
        switch sender.direction {
        case .left:
            self.delegateIndicator?.moveRight()
            self.delegateWeather?.loadWeatherViewByDirection(right: true, index: nil, fromBackground: false)
        case .right:
            self.delegateIndicator?.moveLeft()
            self.delegateWeather?.loadWeatherViewByDirection(right: false, index: nil, fromBackground: false)
        default:
            break
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
