//
//  CityDetails.swift
//  Weather App
//
//  Created by Anshuman Dash on 8/28/18.
//  Copyright © 2018 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

import UIKit

class CityDetails: NSObject {
    var cityName = String()
    var latitude = String()
    var longitude = String()
    var cityId = String()
    
    init(cityName:String,latitude:String,longitude:String,cityId:String) {
        self.cityName = cityName
        self.latitude = latitude
        self.longitude = longitude
        self.cityId = cityId
    }
}
