//
//  Protocols.swift
//  WeatherApp
//
//  Created by tomer on 22/07/2018.
//  Copyright © 2018 tomer. All rights reserved.
//

import Foundation

//inherit by RegisterLoginViewController class
protocol AmazonManagerDelegate {
    func didCompare(isSuccesful : Bool)
}

//inherit by RegisterLoginViewController class
protocol CameraViewControllerDeledate {
    func getImageData(imageData : Data)
}

//inherit by UIIndicatoreView class
protocol UIIndicatoreViewDelegate {
    func moveLeft()
    func moveRight()
}

//inherit by UIWeatherView class
protocol UIWeatherViewDelegate {
    func loadWeatherViewByDirection(right : Bool, index : Int?, fromBackground : Bool)
}
