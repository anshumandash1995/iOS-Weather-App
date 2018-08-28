//
//  ForecastWeather.swift
//  Weather App
//
//  Created by Anshuman Dash on 7/30/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

class ForecastWeather {
    
    private var _date: String!
    private var _temperature: Double!
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var temp: Double {
        if _temperature == nil {
            _temperature = 0.0
        }
        return _temperature
    }
    
    init(weatherDictionary: Dictionary<String,AnyObject>) {
        if let temp = weatherDictionary["temp"] as? Dictionary<String,AnyObject> {
            if let dayTemp = temp["day"] as? Double {
                let rawTemp = (dayTemp - 273.15).rounded(toPlaces: 2)
                self._temperature = rawTemp
            }
        }
        if let date = weatherDictionary["dt"] as? Double {
            let rawDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let currentDate = dateFormatter.string(from: rawDate)
            
            self._date = "\(currentDate)"
        }
    }
}
