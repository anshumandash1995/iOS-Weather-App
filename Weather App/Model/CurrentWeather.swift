//
//  CurrentWeather.swift
//  Weather App
//
//  Created by Anshuman Dash on 7/27/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CurrentWeather {
    private var _cityName: String!
    private var _weatherType: String!
    private var _currentTemperature: Double!
    private var _date: String!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemperature: Double {
        if _currentTemperature == nil {
            _currentTemperature = 0.0
        }
        return _currentTemperature
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    func downloadCurrentWeather(API_URL: String,completed: @escaping DownloadComplete) {
        Alamofire.request(API_URL).responseJSON { (response) in
            //print(response)
            
            let result = response.result
            //print(result.value)

            let json = JSON(result.value)
            
            self._cityName = json["name"].stringValue
            
            let tempDate = json["dt"].doubleValue
            let convertedDate = Date(timeIntervalSince1970: tempDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let currentDate = dateFormatter.string(from: convertedDate)
            self._date = "\(currentDate)"
            
            self._weatherType = json["weather"][0]["main"].stringValue
            
            let downloadedTemperature = json["main"]["temp"].doubleValue
            self._currentTemperature = (downloadedTemperature - 273.35).rounded(toPlaces: 1)
            
            completed()
        }
    }
}
