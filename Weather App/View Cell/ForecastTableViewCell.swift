//
//  ForecastTableViewCell.swift
//  Weather App
//
//  Created by Anshuman Dash on 7/30/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    //MARk:- IBOutlets

    @IBOutlet weak var forecastDateLabel: UILabel!
    @IBOutlet weak var forecastTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureForecastCell(forecastWeatherData: ForecastWeather) {
        self.forecastDateLabel.text = "\(forecastWeatherData.date)"
        self.forecastTemperatureLabel.text = "\(forecastWeatherData.temp)"
    }

}
