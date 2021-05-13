//
//  WeatherData.swift
//  Weather Check
//
//  Created by Onur Mavitas on 12.05.2021.
//

import Foundation

struct WeatherData: Codable {
    let consolidated_weather: [WeatherDetail]
}

struct WeatherDetail: Codable {
    let id: Int
    let weather_state_name: String
    let weather_state_abbr: String
    let wind_direction_compass: String
    let applicable_date: String
    let min_temp: Float
    let max_temp: Float
    let the_temp: Float
    let wind_speed: Float
    let wind_direction: Float
    let air_pressure: Float
    let humidity: Int
    let visibility: Float
    let predictability: Int
    
}
