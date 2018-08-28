//
//  WeatherViewController.swift
//  Weather App
//
//  Created by Anshuman Dash on 7/27/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController,CLLocationManagerDelegate {

    //MARK:- IBOutlets
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityTableView: UITableView!
    
    //MARK:- Instance Variables
    
    var currentWeather: CurrentWeather!
    var currentLocation: CLLocation!
    var forecastWeather: ForecastWeather!
    var forecastWeatherArray: [ForecastWeather] = []
    var isSearch = Bool()
    var cities:[CityDetails] = []
    var filterCities:[CityDetails] = []
    
    let locationManager = CLLocationManager()
    var searchBarInitialHeight:CGFloat!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocation()
        parseCities()
        initialiseVariables()
        locationAuthorizationCheck()
    }
    
    //MARK:- Action Methods
    
    @IBAction func searchAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.searchBarHeightConstraint.constant = self.searchBarInitialHeight
            self.searchBar.becomeFirstResponder()
            self.searchButton.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- Custom Methods
    func initialiseVariables() {
        searchBarInitialHeight = searchBarHeightConstraint.constant
        searchBarHeightConstraint.constant = 0
        cityTableView.isHidden = true
        searchBar.returnKeyType = .done
        applyEffects()
        
        currentWeather = CurrentWeather()
    }
    
    func applyEffects() {
        motionEffects(view: backgroundImageView, intensity: 45)
    }
    
    func motionEffects(view: UIView, intensity: Double) {
        let horizontalMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotion.minimumRelativeValue = -intensity
        horizontalMotion.maximumRelativeValue = intensity
        
//        let verticalMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
//        verticalMotion.minimumRelativeValue = -intensity
//        verticalMotion.maximumRelativeValue = intensity
        
        let movement = UIMotionEffectGroup()
        movement.motionEffects = [horizontalMotion]
        
        view.addMotionEffect(movement)
    }
    
    func updateUI() {
        cityNameLabel.text = currentWeather.cityName
        weatherTypeLabel.text = currentWeather.weatherType
        temperatureLabel.text = "\(currentWeather.currentTemperature)"
        currentDateLabel.text = currentWeather.date
    }
    
    func callLocationManagerDelegate() {
        locationManager.delegate = self
    }
    
    func setUpLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() //Take permission from user
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationAuthorizationCheck() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //Get the location from the device
            currentLocation = locationManager.location
            
            //Pass location co-ordinates to API
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            //Download API data
            let api = UrlHandler.sharedInstance.makeWeatherApi(lat: Location.sharedInstance.latitude, long: Location.sharedInstance.longitude)
            currentWeather.downloadCurrentWeather(API_URL: api) {
                //Update UI
                self.updateUI()
            }
        }
        else {//User did not allow
            locationManager.requestWhenInUseAuthorization() //Take permission from user again
            locationAuthorizationCheck()
        }
        let apiForecast = UrlHandler.sharedInstance.makeForeCastApi(lat: Location.sharedInstance.latitude, long: Location.sharedInstance.longitude)
        downloadForecastWeatherData(FORECAST_API_URL: apiForecast) {
            print("Data Downloaded")
        }
    }
    
    func downloadForecastWeatherData(FORECAST_API_URL: String,completed: @escaping DownloadComplete) {
        Alamofire.request(FORECAST_API_URL).responseJSON { (response) in
            let result = response.result
            if let dict = result.value as? Dictionary<String,AnyObject> {
                if let list = dict["list"] as? [Dictionary<String,AnyObject>] {
                    for item in list {
                        let forecast = ForecastWeather(weatherDictionary: item)
                        self.forecastWeatherArray.append(forecast)
                    }
                    self.forecastWeatherArray.remove(at: 0)
                    self.forecastTableView.reloadData()
                }
            }
        }
        completed()
    }
    
    func searchCity(key: String) {
        if isSearch {
            filterCities = cities.filter({ (model) -> Bool in
                if model.cityName.uppercased().contains(key.uppercased()){
                    return true
                }
                return false
            })
        }
        else {
           filterCities = cities
        }
        cityTableView.reloadData()
    }
    
    func checkEmpty(text:String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
}

//MARK:- UITableView DataSource & Delegate

extension WeatherViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cityTableView {
            if isSearch {
                return filterCities.count
            }
            else {
                return 0
            }
        }
        else {
            return forecastWeatherArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == cityTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
            cell.textLabel?.text = filterCities[indexPath.row].cityName
            cell.detailTextLabel?.text = ""
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell
            cell.configureForecastCell(forecastWeatherData: forecastWeatherArray[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == cityTableView {
            let lat = (Double(filterCities[indexPath.row].latitude)?.rounded(toPlaces: 2))!
            print(lat)
            let long = (Double(filterCities[indexPath.row].longitude)?.rounded(toPlaces: 2))!
            forecastWeatherArray = []
            
            searchBar.resignFirstResponder()
            let apiWeather = UrlHandler.sharedInstance.makeWeatherApi(lat: lat, long: long)
            let apiForecast = UrlHandler.sharedInstance.makeForeCastApi(lat: lat, long: long)
            currentWeather.downloadCurrentWeather(API_URL: apiWeather) {
                //Update UI
                self.updateUI()
            }
            downloadForecastWeatherData(FORECAST_API_URL: apiForecast) {
                print("Data Downloaded")
            }
            searchBar.resignFirstResponder()
            UIView.animate(withDuration: 0.5) {
                self.searchBarHeightConstraint.constant = 0
                self.searchButton.isHidden = false
                self.cityTableView.isHidden = true
                self.searchBar.text = ""
                self.view.layoutIfNeeded()
            }
        }
    }
}

//MARK:- UISearchBar Delegate

extension WeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.cityTableView.isHidden = false
        if let textValue = searchBar.text,
            let textRange = Range(range, in: textValue) {
            let updatedText = textValue.replacingCharacters(in: textRange,
                                                            with: text)
            if !checkEmpty(text: updatedText)
            {
                isSearch = true
                self.searchCity(key: updatedText)
            }
            else
            {
                isSearch = false
                self.searchCity(key: updatedText)
            }
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.5) {
            self.searchBarHeightConstraint.constant = 0
            self.searchButton.isHidden = false
            self.cityTableView.isHidden = true
            self.searchBar.text = ""
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearch = false
            cityTableView.isHidden = true
            self.searchCity(key: "")
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        UIView.animate(withDuration: 0.5) {
            self.searchBarHeightConstraint.constant = 0
            self.searchButton.isHidden = false
            self.cityTableView.isHidden = true
            self.searchBar.text = ""
            self.view.layoutIfNeeded()
        }
    }
}

//MARK:- JSON Parse

extension WeatherViewController {
    func parseCities() {
        guard let fileURL = Bundle.main.url(forResource: "citiesCoordinate", withExtension: "json") else {
                print("Error Finding JSON File")
                return
        }
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let jsonObject = try JSON(data: jsonData)
            
            let cityArray = jsonObject["features"].arrayValue
            for cityData in cityArray {
                let cityName = cityData["properties"]["city"].stringValue
                let id = cityData["id"].stringValue
                let coordinates = cityData["geometry"]["coordinates"].arrayValue
                let latitude = coordinates[1].stringValue
                let longitude = coordinates[0].stringValue
                
                let city = CityDetails(cityName: cityName, latitude: latitude, longitude: longitude, cityId: id)
                cities.append(city)
            }
            cities = cities.sorted(by: {$0.cityName < $1.cityName})
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
