//
//  ViewController.swift
//  OWA
//
//  Created by Leart on 1/18/19.
//  Copyright © 2019 RudiLeart. All rights reserved.
//

import UIKit
import HPOpenWeather
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, ChangeCityDelegate{
    
    // MARK: - Properties
    var cityName = "New+York"
    var forecastData: Forecast!
    var smallDesc = [String]()
    var tempMin = [Double]()
    var tempMax = [Double]()
    var longitude: Double = 0
    var latitude: Double = 0
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherCondition: UIImageView!
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var temperatureLable: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        coordsWeather()
//        coordsForcast()
        getWeatherByCity(name: cityName)
        getForcast()
        tableView.delegate = self
        tableView.reloadData()
    }
    
    var weatherAPI = OpenWeatherSwift(apiKey: "7b79a1ba8ceae740e5cde928d4603888", temperatureFormat: .Celsius)
    
    // MARK: - Current Weather
    func getWeatherByCity(name: String){
        weatherAPI.currentWeatherByCity(name: cityName) { (results) in
            let weather = Weather(data: results)
            self.cityLable.text = String(weather.location.description)
            self.temperatureLable.text = String(weather.temperature) + "°C"
            if weather.condition == "Clear"{
                self.weatherCondition.image  = UIImage(named: "Sunny")
            }else if weather.condition == "Snow"{
                self.weatherCondition.image  = UIImage(named: "Snow")
            }else if weather.condition == "Rain"{
                self.weatherCondition.image  = UIImage(named: "Rainy")
            }
            if self.cityName.uppercased() == "NEW+YORK"{
                self.cityImage.image = UIImage(named: "NY")
            }else if self.cityName.uppercased() == "SAN+FRANCISCO" {
                self.cityImage.image = UIImage(named: "SF")
            }
        }
    }
    
    // MARK: - Forcast
    func getForcast(){
        weatherAPI.forecastWeatherByCity(name: cityName, type: ForecastType.Daily) { (results) in
            self.forecastData = Forecast(data: results, type: ForecastType.Daily)
            self.smallDesc = self.forecastData.weatherSmallDesc
            print(self.smallDesc)
            self.tempMin = self.forecastData.tempMin
            print(self.tempMin)
            self.tempMax = self.forecastData.tempMax
            print(self.tempMax)
            print(self.forecastData.icon)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellData", for: indexPath) as! CellView
        
        if !smallDesc.isEmpty {
            cell.smallDesc.text = String(self.smallDesc[indexPath.row])
            cell.minTemp.text = String(Int(self.tempMin[indexPath.row]))
            cell.maxTemp.text = String(Int(self.tempMax[indexPath.row].rounded()))
            if smallDesc[indexPath.row] == "Clear" {
                cell.weatherCondition.image = UIImage(named: "Sun")
            }else if smallDesc[indexPath.row] == "Rain"{
                cell.weatherCondition.image = UIImage(named: "Drop")
            }else if smallDesc[indexPath.row] == "Snow"{
                cell.weatherCondition.image = UIImage(named: "Snowflake")
            }else if smallDesc[indexPath.row] == "Clouds"{
                cell.weatherCondition.image = UIImage(named: "Cloud")
            }else{
                cell.weatherCondition.image = UIImage(named: "Sun")
            }
        }
        return cell
    }
    
    //MARK: - Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            longitude = location.coordinate.longitude
            latitude = location.coordinate.latitude
        }
    }
    
    func coordsWeather(){
        weatherAPI.currentWeatherByCoordinates(coords: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)) { (results) in
            let weather = Weather(data: results)
            print(self.latitude)
            print(self.longitude)
            self.cityLable.text = weather.location.description
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        self.cityLable.text = "Location Unavailable"
    }
    
    func coordsForcast(){
        weatherAPI.forecastWeatherByCoordinates(coords: CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude), type: ForecastType.Daily) { (results) in
            self.forecastData = Forecast(data: results, type: ForecastType.Daily)
            self.smallDesc = self.forecastData.weatherSmallDesc
            print(self.smallDesc)
            self.tempMin = self.forecastData.tempMin
            print(self.tempMin)
            self.tempMax = self.forecastData.tempMax
            print(self.tempMax)
            print(self.forecastData.icon)
            self.tableView.reloadData()
        }
    }
    
    //MARK : Change City Button
    @IBAction func changeCityBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "goTo", sender: self)
    }
    
    //MARK : Change City Delegate
    func userEnteredCityName(cityName: String) {
        self.cityName = cityName
        getWeatherByCity(name: cityName)
        getForcast()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTo" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
}

