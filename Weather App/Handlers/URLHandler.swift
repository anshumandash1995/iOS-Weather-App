//
//  URLHandler.swift
//  Weather App
//
//  Created by Anshuman Dash on 7/27/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

class UrlHandler{
    static var sharedInstance = UrlHandler()
    
    func makeWeatherApi(lat: Double, long: Double) -> String{
        return "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=7c609f73c5df2dff2f32e3e3cc33cd23"
    }
    
    func makeForeCastApi(lat: Double, long: Double) -> String{
        return "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(long)&cnt=11&appid=7c609f73c5df2dff2f32e3e3cc33cd23"
    }
}

typealias DownloadComplete = () -> ()
