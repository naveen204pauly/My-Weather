//
//  DailyWeather.swift
//  MyWeather
//
//  Created by Naveen PaulSingh on 20/02/23.
//

import Foundation

struct DailyWeather: Codable {
    let lat,lon: Double
    let hourly: [Hourly]
    let daily: [Daily]
    let current: Hourly
}


struct Daily: Codable {
    let dt: TimeInterval
    let weather: [WeatherIcon]
    let temp: Temp
}

struct Hourly: Codable {
    let dt: TimeInterval
    let weather: [WeatherIcon]
    let temp: Double
}

struct WeatherIcon: Codable {
    let icon: String
}


struct Temp: Codable {
    let min: Double
    let max: Double
}
