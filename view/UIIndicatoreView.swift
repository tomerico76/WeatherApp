//
//  UIIndicatoreView.swift
//  WeatherApp
//
//  Created by tomer on 15/07/2018.
//  Copyright © 2018 tomer. All rights reserved.
//

import UIKit

class UIIndicatoreView: UIView, UIGestureRecognizerDelegate, UIIndicatoreViewDelegate {
 
    //MARK: - properties -
    var delegateWeather : UIWeatherViewDelegate?
    
    var indicatoresArr : [UIImageView] = []
    var pressedIconIndex : Int = 0
    private var _numberOfItems : Int = 0
    
    //MARK: - computed properties -
    static var iconSize : CGFloat{
        get{
            return 24
        }
    }
    
    static var iconSpacing : CGFloat{
        get{
            return 3
        }
    }
 
    static var viewHeight : CGFloat{
        get{
            return 30
        }
    }
    
    //the caculated width, by the number of items(city array count)
    var viewWidth : CGFloat{
        get{
            return (UIIndicatoreView.iconSize * CGFloat(_numberOfItems)) + (CGFloat(_numberOfItems + 1) * UIIndicatoreView.iconSpacing)
        }
    }
    
    //can be seen in the storyboard
    @IBInspectable var numberOfItems : Int{
        set{
            if newValue > 10{
                self.numberOfItems = 10
                _numberOfItems = 10
            }else if newValue < 1{
                _numberOfItems = 1
            }else{
                _numberOfItems = newValue
            }
        }
        get{
            return _numberOfItems
        }
    }
    
    //MARK: - init functions -
    //from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //from code
    init(frame: CGRect, numberOfItems : Int) {
        _numberOfItems = numberOfItems
        
        let tempFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: UIIndicatoreView.viewHeight)
        super.init(frame: tempFrame)
        setup()
    }
    
    private func setup(){
        print("setup")
        //self.backgroundColor = .red
        validateWidth()
        populateView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesturePressed))
        gesture.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    
    //checks if the calculated width is bigger then the actual(init) width
    //if it is bigger, it will reduce the number of items(icons) to the correct number
    //that fits the actual(init) width.
    //this process will determine if the weather array and the stand by array needs to be shortend
    private func validateWidth(){
        print("validateWidth")
        if self.viewWidth > self.frame.width{
            for i in 1...self.numberOfItems{
                let temp = (UIIndicatoreView.iconSize * CGFloat(_numberOfItems - i)) + (CGFloat(_numberOfItems - i + 1) * UIIndicatoreView.iconSpacing)
                if temp < self.frame.width{
                    self.numberOfItems -= i
                    break
                }
            }
        }
    }
    
    private func populateView(){
        print("populateView")
        let tempOriginX = (self.frame.width - viewWidth) / 2
        let tempOriginY = (self.frame.height / 2) - (UIIndicatoreView.viewHeight / 2)
        let inerViewRect = CGRect(x: tempOriginX, y: tempOriginY, width: self.viewWidth, height: UIIndicatoreView.viewHeight)
        
        let inerView = UIView(frame: inerViewRect)
        var iconRect = CGRect(x: UIIndicatoreView.iconSpacing, y: UIIndicatoreView.iconSpacing, width: UIIndicatoreView.iconSize, height: UIIndicatoreView.iconSize)
        
        for _ in 0..<self.numberOfItems{
            let imageView = UIImageView(frame: iconRect)
            imageView.image =  UIImage(named: "icon_circle")
            imageView.contentMode = .scaleToFill
            imageView.highlightedImage = UIImage(named: "icon_filled_circle")
            //imageView.backgroundColor = .yellow
            indicatoresArr.append(imageView)
            inerView.addSubview(imageView)
            iconRect.origin.x += UIIndicatoreView.iconSize + UIIndicatoreView.iconSpacing
        }

        indicatoresArr.first?.isHighlighted = true
        //inerView.backgroundColor = .white
        inerView.isUserInteractionEnabled = false
        self.addSubview(inerView)
    }
    
    //MARK: - gesture functions -
    @objc func tapGesturePressed(sender: UITapGestureRecognizer) {
        print("tapGesturePressed")
        let ic = indicatoresArr.first
        
        let icon = getPressedView(coordinate: sender.location(in: ic))
        guard let iconView = icon as? UIImageView else {
            print("no icon")
            return
        }
        iconView.isHighlighted = !iconView.isHighlighted
    }
    
    private func getPressedView(coordinate : CGPoint) -> UIView?{
        var tempView : UIView? = nil
        if !self.indicatoresArr.isEmpty{
            for i in 0..<indicatoresArr.count{
                let item = indicatoresArr[i]
                if item.frame.contains(coordinate){
                    tempView = item
                    indicatoresArr[pressedIconIndex].isHighlighted = false
                    pressedIconIndex = i
                    self.delegateWeather?.loadWeatherViewByDirection(right: true, index: pressedIconIndex, fromBackground: false)
                    break
                }
            }
        }else{
            return tempView
        }
        return tempView
    }
    
    //MARK: - delegate functions -
    func moveLeft() {
        if self.pressedIconIndex > 0{
            indicatoresArr[self.pressedIconIndex].isHighlighted = false
            self.pressedIconIndex -= 1
            indicatoresArr[self.pressedIconIndex].isHighlighted = true
        }
    }
    
    func moveRight() {
        print("moveRight")
        if self.pressedIconIndex < indicatoresArr.count - 1{
            indicatoresArr[self.pressedIconIndex].isHighlighted = false
            self.pressedIconIndex += 1
            indicatoresArr[self.pressedIconIndex].isHighlighted = true
        }
    }
}
