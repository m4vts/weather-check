//
//  WeatherManager.swift
//  Weather Check
//
//  Created by Onur Mavitas on 11.05.2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateCities(_ weatherManager: WeatherManager, cities: [CityModel])
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: [WeatherDetail])
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://www.metaweather.com/api/location/search/"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        
        let urlString = "\(weatherURL)?query=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)?lattlong=\(latitude),\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let citiesArray = self.parseJSON(cityData: safeData) {
                        self.delegate?.didUpdateCities(self, cities: citiesArray)
                    }
                }
            }
            
            task.resume()
        }
    }
    func parseJSON(cityData: Data) -> [CityModel]? {
        var cities: [CityModel] = Array()
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([CityLocation].self, from: cityData)
            
            for item in decodedData {
                let woeid = item.woeid
                let title = item.title
                let location_type = item.location_type
                let latt_long = item.latt_long
                
                let city = CityModel(title: title, location_type: location_type, woeid: woeid, latt_long: latt_long)
                cities.append(city)
            }
            return cities
            
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }

    }
    
//MARK: - Temp
    
    func fetchTemp(with woeid: Int) {

        let urlString = "https://www.metaweather.com/api/location/\(woeid)"
        performTempRequest(with: urlString)
    }
    
    func performTempRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let config = URLSessionConfiguration.default
            config.waitsForConnectivity = true
            config.timeoutIntervalForResource = 20
            
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseTempJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseTempJSON(weatherData: Data)  -> [WeatherDetail]? {
        var weatherArray: [WeatherDetail]
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            weatherArray = decodedData.consolidated_weather
            return weatherArray
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }

    }
}
