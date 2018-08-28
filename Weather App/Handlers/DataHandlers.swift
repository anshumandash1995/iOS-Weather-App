//
//  DataHandlers.swift
//  Weather App
//
//  Created by Anshuman Dash on 7/27/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

//Rounds the double to decimal places value

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//Date Extension to covert date to a day in String type.

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
